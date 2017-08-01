FROM php:7.1-fpm

LABEL maintainer="luca@theaveragedev.com"

# install required PHP extensions
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        apt-utils \
        curl \
        git \
        zip unzip\
        libjpeg-dev \
        libpng12-dev \
        libpng12-0 \
        libjpeg62-turbo \
        less \
        ssmtp; \
    \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install gd mysqli opcache zip

# install and enable Xdebug and Opcache
RUN pecl install xdebug-2.5.5 \
    && docker-php-ext-enable opcache xdebug

# clean dependencies
RUN buildDeps=" \
            libjpeg-dev \
    " \
    && rm -r /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps

# set the PHP user, (www-data), to the UID 1000 to allow it to rwx on the folders
RUN usermod -u 1000 www-data

# install ssmtp to connect to the Mailcatcher container
RUN echo "sendmail_path = /usr/sbin/ssmtp -t" > /usr/local/etc/php/conf.d/sendmail.ini \
    && echo "mailhub=mail:25\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

# install wp-cli in /usr/local/bin
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp \
    && wp --version --allow-root

# install composer in /usr/local/bin
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin \
    && mv /usr/local/bin/composer.phar /usr/local/bin/composer \
    && php -r "unlink('composer-setup.php');" \
    && composer --version \
RUN composer global require hirak/prestissimo

# configure PHP extensions
COPY conf/xdebug.ini /usr/local/etc/php/conf.d/xdebug-conf.ini
COPY conf/opcache.ini /usr/local/etc/php/conf.d/opcache-conf.ini

# install wp-browser and dotenv globally for the PHP user (www-data)
RUN COMPOSER_HOME=/var/www/.composer composer global require lucatume/wp-browser
RUN COMPOSER_HOME=/var/www/.composer composer global require vlucas/phpdotenv

# link bins we need in /usr/local/bin
RUN ln -s /var/www/.composer/vendor/bin/codecept /usr/local/bin

# allow OpCache and XDebug configuration files to be manipulated by non root user
RUN chmod a+rw /usr/local/etc/php/conf.d \
    && chmod a+rw /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && chmod a+rw /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && chmod a+rw /usr/local/etc/php/conf.d/xdebug-conf.ini \
    && chmod a+rw /usr/local/etc/php/conf.d/opcache-conf.ini

COPY entrypoint /usr/local/bin/
RUN chmod +rx /usr/local/bin/entrypoint

# run as the PHP user (www-data)
USER www-data

ENTRYPOINT ["entrypoint"]
