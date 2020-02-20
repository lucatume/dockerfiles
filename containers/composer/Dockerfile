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

# Speed Composer installations up.
RUN composer global require hirak/prestissimo

# Neat helper to install the required PHP extensions.
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# Install required PHP extensions.
RUN install-php-extensions gd zip

WORKDIR /project

ENTRYPOINT ["composer"]
