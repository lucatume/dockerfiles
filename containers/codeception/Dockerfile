ARG CODECEPTION_VERSION

FROM codeception/codeception:${CODECEPTION_VERSION}

LABEL maintainer="Luca Tumedei <luca@theaveragedev.com>"

# Install packages that might turn out to be useful.
RUN apt-get update && \
 	apt-get install -y --no-install-recommends mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Install required PHP extensions.
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions pdo_mysql gd mysqli uopz

# Set up the Docker entrypoint script.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# The entypoint script will wait for WordPress database to be available, if the relevant db env vars are set.
# Furthermore the script will redirect the commands to the project codecept binary, if that is available.
ENTRYPOINT ["docker-entrypoint.sh"]
