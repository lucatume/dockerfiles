#!/usr/bin/env bash

if [[ "${UID}:${GID}" != "0:0" ]]; then
    echo -e "\033[32mFixing file ownership issues...\033[0m"
    # Use fixuid to remap UID and GID correctly in the /composer folders.
    eval $(fixuid)
else
    echo 'If you are encountering file ownership issues, run this container using the "--user ${UID}:${GID}" option.'
    echo 'The issues should be fixed for you.'
fi

COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_HOME=/composer COMPOSER_CACHE=/composer/cache composer $@
