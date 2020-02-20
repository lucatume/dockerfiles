#!/bin/sh

set -e
cmd="$@"

dbhost="${WORDPRESS_DB_HOST:-$WP_DB_HOST}"
dbname="${WORDPRESS_DB_NAME:-$WP_DB_NAME}"
dbuser="${WORDPRESS_DB_USER:-$WP_DB_USER}"
dbpass="${WORDPRESS_DB_PASSWORD:-$WP_DB_PASSWORD}"

if [ -n "${dbhost}" ] && [ -n "${dbname}" ] && [ -n "${dbuser}" ]; then
  timeout=0
  timeout_message="WordPres did not come up in one minute: check db credentials or the WordPress container healt."

  until php -r "new PDO('mysql:host=${dbhost};dbname=${dbname}', '${dbuser}', '${dbpass}');" >/dev/null 2>&1; do
    timeout=$((timeout + 1))
    test $timeout -lt 30 || (echo "${timeout_message}" && exit 1)
    echo >&2 "WordPress db is unavailable, waiting..."
    sleep 2
  done

  echo >&2 "WordPress up, executing command."
else
  echo "WordPress database environment variables, (WP|WORDPRESS)_DB_(HOST|NAME|USER|PASSWORD), not provided, skipping database checks."
fi

exec $cmd
