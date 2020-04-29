#!/usr/bin/env bash

set -e

CHECK_DB_HOST="${WORDPRESS_DB_HOST:-$WP_DB_HOST}"
CHECK_DB_NAME="${WORDPRESS_DB_NAME:-$WP_DB_NAME}"
CHECK_DB_USER="${WORDPRESS_DB_USER:-$WP_DB_USER}"
CHECK_DB_PASSWORD="${WORDPRESS_DB_PASSWORD:-$WP_DB_PASSWORD}"
CHECK_URL="${WORDPRESS_URL:-$WP_URL}"
SKIP_DB_CHECK=${CODECEPTION_SKIP_DB_CHECK:-0}
SKIP_URL_CHECK=${CODECEPTION_SKIP_URL_CHECK:-0}
SKIP_BIN_CHECK=${CODECEPTION_SKIP_BIN_CHECK:-0}

# Disable the XDebug extension if XDEBUG_DISABLE=1.
test "${XDEBUG_DISABLE:-0}" == 1 && {
  # Play the pipe game to avoid dealing with temp file issues.
  XDEBUG_CONFIGURATION_FILE="/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"
  XDEBUG_CONFIGURATION=$(cat "${XDEBUG_CONFIGURATION_FILE}")
  echo "${XDEBUG_CONFIGURATION}" | sed -e '/^zend_extension.*xdebug/s/^zend_extension/;zend_extension/g' >"${XDEBUG_CONFIGURATION_FILE}"
  echo -e "\033[32mXDebug extension disabled.\033[0m"
}

function fix_uid() {
  if [[ "${UID}:${GID}" != "0:0" ]]; then
    echo -e "\033[32mFixing file ownership issues...\033[0m"
    # Use fixuid to remap UID and GID correctly in the /project folders.
    eval "$(fixuid)"
  else
    echo "If you are encountering file ownership issues, run this container using the '--user ${UID}:${GID}' option."
    echo 'The issues should be fixed for you.'
  fi
}

test "${FIXUID:-1}" != "0" && fix_uid

if [ "0" == "${SKIP_DB_CHECK}" ]; then
  if [ -n "${CHECK_DB_HOST}" ] && [ -n "${CHECK_DB_NAME}" ] && [ -n "${CHECK_DB_USER}" ]; then
    timeout=0
    timeout_message="\033[031mWordPress database not available: check db credentials or the WordPress container health.\033[0m"

    until php -r "new PDO('mysql:host=${CHECK_DB_HOST};CHECK_DB_NAME=${CHECK_DB_NAME}', '${CHECK_DB_USER}', '${CHECK_DB_PASSWORD}');" >/dev/null 2>&1; do
      timeout=$((timeout + 1))
      test $timeout -lt 30 || (echo -e "${timeout_message}" && exit 1)
      echo "WordPress db is unavailable, waiting..."
      sleep 2
    done

    echo -e "\033[32mWordPress db up.\033[0m"
  else
    echo "WordPress database environment variables (WP|WORDPRESS)_DB_(HOST|NAME|USER|PASSWORD) not provided, skipping database checks."
  fi
else
  echo "CODECEPTION_SKIP_DB_CHECK set to 1, skipping db checks."
fi

if [ "0" == "${SKIP_URL_CHECK}" ]; then
  if [ -n "${CHECK_URL}" ]; then
    echo "Waiting for WordPress site to be available at ${CHECK_URL}..."
    if [ "$(curl -Lkf --retry-connrefused --retry 15 --retry-delay 2 -o /dev/null --stderr /dev/null "${CHECK_URL}")" ]; then
      echo -e "\033[31mWordPress site at ${CHECK_URL} not available: check db credentials or the WordPress container health.\033[0m"
      exit 1
    fi
  else
    echo "WORDPRESS_URL and WP_URL not set, skipping web-server checks."
  fi
  echo -e "\033[32mWordPress available at ${CHECK_URL}.\033[0m"
else
  echo "CODECEPT_SKIP_URL_CHECK set to 1, skipping web-server checks."
fi

# Sleep a further delay if the CODECEPTION_WAIT env var is set.
[ -n "${CODECEPTION_WAIT}" ] && echo "Waiting ${CODECEPTION_WAIT} seconds..." && sleep "${CODECEPTION_WAIT}"

if [ -n "${CODECEPTION_PROJECT_DIR}" ]; then
  test -d "${CODECEPTION_PROJECT_DIR}" || CODECEPTION_PROJECT_DIR="/project/${CODECEPTION_PROJECT_DIR}"
  echo "Changing directory to ${CODECEPTION_PROJECT_DIR}"
  cd "${CODECEPTION_PROJECT_DIR}"
fi

CODECEPTION_PROJECT_DIR=${CODECEPTION_PROJECT_DIR:-/project}

if [ "0" == "${SKIP_BIN_CHECK}" ] && [ -f "${CODECEPTION_PROJECT_DIR}/vendor/bin/codecept" ]; then
  # If the project does have Codeception installed, then call the project codecept binary directly.
  echo -e "\033[32mUsing project Codeception binary.\033[0m"
  echo ''
  CODECEPTION_BIN="${CODECEPTION_PROJECT_DIR}/vendor/bin/codecept"
else
  # Else fall-back and use the codecept binary provided from the original codeception container.
  CODECEPTION_BIN=/repo/codecept
fi

# If the first command is `bash`, then execute a bash command, not a Codeception one.
if [ "$1" == 'bash' ]; then
  # If the first command is `bash`, then execute a bash command, not a Codeception one.
  echo -e "\e[32mCommand starts with 'bash': opening a bash shell.\e[0m"
  if [ -d "${HOME}" ]; then
    printf "Adding the following aliases:\n"
    printf "  - \e[32mc\e[0m => %s\n" "${CODECEPTION_BIN}"
    printf "  - \e[32mcr\e[0m => %s run\n" "${CODECEPTION_BIN}"
    printf "  - \e[32mxon\e[0m => Activate XDebug extension\n"
    printf "  - \e[32mxoff\e[0m => Deactivate Xdebug extension\n"
    # Add some useful aliases.
    (
      printf "\nalias c='%s'\nalias cr='%s run'" "${CODECEPTION_BIN}" "${CODECEPTION_BIN}";
      printf "\nfunction xoff(){\n\tsed -i '/^zend_extension/ s/^zend_extension/;zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \n}";
      printf "\nfunction xon(){\n\tsed -i '/^;zend_extension/ s/^;zend_extension/zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \n}\n"
    ) >>${HOME}/.bashrc
    echo ""
  fi
  exec "$@"
else
  exec "${CODECEPTION_BIN}" "$@"
fi
