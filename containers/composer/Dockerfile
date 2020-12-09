ARG PHP_VERSION
ARG COMPOSER_VERSION

FROM composer:${COMPOSER_VERSION} as composer

FROM php:${PHP_VERSION}-cli

LABEL maintainer="Luca Tumedei <luca@theaveragedev.com>"

COPY --from=composer /usr/bin/composer /usr/bin/composer

# Install packages required by Composer.
RUN apt-get update && \
 	apt-get install -y --no-install-recommends curl git zip unzip && \
    rm -rf /var/lib/apt/lists/*

# Neat helper to install the required PHP extensions.
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN if [ "$(printf %.1s "${PHP_VERSION}")" != "8" ]; \
    then \
        install-php-extensions gd zip imagick; \
    else \
        install-php-extensions gd zip; \
    fi

# Create a `docker` user to run the container not as root.
RUN addgroup --gid 1000 docker && \
    adduser --uid 1000 --ingroup docker --home /home/docker --shell /bin/sh --disabled-password --gecos "" docker && \
    mkdir -p /composer/cache

# Install hirak/prestissimo only on Composer v1.
RUN export COMPOSER_MAJOR_VERSION="$(printf %.1s "${COMPOSER_VERSION}")"
RUN if [ "${COMPOSER_MAJOR_VERSION}" = "1" ]; then \
        export COMPOSER_HOME=/composer && \
        export COMPOSER_ALLOW_SUPERUSER=1 && \
        composer global require hirak/prestissimo; \
    fi

# Download and set up the fixuid script.
RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\npaths: [ '/composer' ]" > /etc/fixuid/config.yml && \
    chown -R ${USER}:${GROUP} /composer

# Remove the PHP memory limit and verify it.
RUN php -r "echo 'PHP memory_limit before memory_limit modification: ' . ini_get('memory_limit') . PHP_EOL;" && \
    echo "PHP ini files before memory_limit modification:" && \
    php --ini && \
    echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini && \
    echo "PHP ini files after memory_limit modification:" && \
    php --ini && \
    php -r "echo 'PHP memory_limit after memory_limit modification: ' . ini_get('memory_limit') . PHP_EOL;"

# Set up the docker entrypoint script.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

USER docker:docker
WORKDIR /project

ENTRYPOINT ["docker-entrypoint.sh"]
