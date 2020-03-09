FROM php:7.4-cli-alpine

LABEL maintainer="Luca Tumedei <luca@theaveragedev.com>"

ARG PHPSTAN_VERSION=0.12
ARG PHPSTAN_WORDPRESS_VERSION=0.6

ENV COMPOSER_HOME /composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH /composer/vendor/bin:$PATH
ENV PHP_CONF_DIR=/usr/local/etc/php/conf.d

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN echo "memory_limit=-1" > $PHP_CONF_DIR/99_memory-limit.ini \
    && apk --no-cache add git \
    && /var/tmp/* /tmp/*

RUN composer global require phpstan/phpstan:"^$PHPSTAN_VERSION" \
    szepeviktor/phpstan-wordpress:"^${PHPSTAN_WORDPRESS_VERSION}"

VOLUME ["/project"]
WORKDIR /project

ENTRYPOINT ["phpstan"]
