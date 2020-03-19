#!/usr/bin/env bash

set -e

dbhost="${WORDPRESS_DB_HOST:-$WP_DB_HOST}"
dbname="${WORDPRESS_DB_NAME:-$WP_DB_NAME}"
dbuser="${WORDPRESS_DB_USER:-$WP_DB_USER}"
dbpass="${WORDPRESS_DB_PASSWORD:-$WP_DB_PASSWORD}"

if [[ "${UID}:${GID}" != "0:0" ]]; then
    echo -e "\033[32mFixing file ownership issues...\033[0m"
    echo -e "See: https://github.com/boxboat/fixuid"
    # Use fixuid to remap UID and GID correctly in the /project and /composer folders.
    eval $(fixuid)
else
    echo 'If you are encountering file ownership issues, run this container using the "--user ${UID}:${GID}" option.'
    echo 'The issues should be fixed for you.'
fi

if [ -n "${dbhost}" ] && [ -n "${dbname}" ] && [ -n "${dbuser}" ]; then
  timeout=0
  timeout_message="WordPress did not come up: check db credentials or the WordPress container health."

  until php -r "new PDO('mysql:host=${dbhost};dbname=${dbname}', '${dbuser}', '${dbpass}');" >/dev/null 2>&1; do
    timeout=$((timeout + 1))
    test $timeout -lt 30 || (echo "${timeout_message}" && exit 1)
    echo "WordPress db is unavailable, waiting..."
    sleep 2
  done

  echo "WordPress up, executing command."
else
  echo "WordPress database environment variables (WP|WORDPRESS)_DB_(HOST|NAME|USER|PASSWORD) not provided, skipping database checks."
fi

if [ -f /project/vendor/bin/codecept ]; then
# If the project does have Codeception installed, then call the project codecept binary directly.
  echo "Using project Codeception binary."
  alias codecept="/project/vendor/bin/codecept"
  CODECEPT_BIN="/project/vendor/bin/codecept"
else
  # Else fall-back and use the codecept binary provided from the original codeception container.
  CODECEPT_BIN=/repo/codecept
fi

exec "${CODECEPT_BIN}" $@
