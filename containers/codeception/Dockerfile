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

# Set up the `wait-then` command.
COPY wait-then.sh /usr/local/bin/wait-then
RUN chmod +x /usr/local/bin/wait-then

# If WordPress database env vars are set, then wait for WordPress database to be available.
ENTRYPOINT ["wait-then", "codecept"]
