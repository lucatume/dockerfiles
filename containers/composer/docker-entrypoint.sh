#!/usr/bin/env bash

if [ ! -d /project ]; then
    PHP_VERSION="$(php -r 'echo PHP_VERSION;')"
    echo -e '\033[31mThe /project directory does not exist: did you share your project in the /project directory?\033[0m'
    echo ''
    echo -e '\033[32mUse the "--user" option to avoid file permission issues.\033[0m'
    echo -e '\033[32mShare your Composer auth.json file with the container to avoid git pull auth issues.\033[0m'
    echo ''
    echo 'docker run --rm \'
    echo '  --user ${GID}:${GID} \'
    echo '  -v $(pwd):/project \'
    echo '  -v "${HOME}/.composer/auth.json:/composer/auth.json" \'
    echo "  lucatume/composer:php${PHP_VERSION:0:3} --version"
    exit 1
fi

if [[ "${UID}:${GID}" != "0:0" ]]; then
    echo -e "\033[32mFixing file ownership issues w/ fixuid...\033[0m"
    echo -e "See: https://github.com/boxboat/fixuid"
    # Use fixuid to remap UID and GID correctly in the /project and /composer folders.
    eval $(fixuid)
else
    echo 'If you are encountering file ownership issues, run this container using the "--user ${GID}:${GID}" option.'
    echo 'The issues should be fixed for you.'
fi

cd /project
COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_HOME=/composer COMPOSER_CACHE=/composer/cache composer $@
