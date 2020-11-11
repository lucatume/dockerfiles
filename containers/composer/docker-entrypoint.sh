#!/usr/bin/env bash

function fix_uid(){
		if [[ "${UID}:${GID}" != "0:0" ]]; then
				echo -n "Fixing file ownership issues ..."
				# Use fixuid to remap UID and GID correctly in the /composer folders.
				eval "$(fixuid -q)"
				echo -e " \e[32mdone\e[0m"
		else
				echo "If you are encountering file ownership issues, run this container using the '--user ${UID}:${GID}' option."
				echo "The issues should be fixed for you."
		fi
}

test "${FIXUID:-1}" != "0" && fix_uid

COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_HOME=/composer COMPOSER_CACHE=/composer/cache composer "$@"
