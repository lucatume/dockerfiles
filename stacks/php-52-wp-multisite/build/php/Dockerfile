FROM tommylau/php-5.2

LABEL maintainer "luca@theaveragedev.com"

VOLUME /var/www/html

# change the ownership of the /var/www/html folder to www-data
# to allow the application to write files 
RUN chown -R www-data: /var/www/html

# install dependencies we need
RUN apt-get update && \
    apt-get install -y wget zip build-essential php5-dev --no-install-recommends

# download and build XDebug
RUN wget https://xdebug.org/files/xdebug-2.2.7.tgz -P $(pwd) && \
    tar -xvzf xdebug-2.2.7.tgz && \
    (cd xdebug-2.2.7; \
    phpize; \
    ./configure > /dev/null; \
    make > /dev/null)

# move Xdebug to the modules folder
RUN mkdir -p /usr/local/etc/php/modules && \
    cp xdebug-2.2.7/modules/xdebug.so /usr/local/etc/php/modules && \
    rm -rf $(pwd)/xdebug*

# activate Xdebug on php
COPY conf/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# install Opcache
RUN pecl install zendopcache-7.0.2

# activate Opcache on php
COPY conf/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# install Memcache extension
RUN pecl install memcache

# activate Memcache on php
COPY conf/memcache.ini /usr/local/etc/php/conf.d/memcache.ini

# clean up dependencies
RUN apt-get --purge remove -y wget zip build-essential php5-dev && \
    apt-get clean -y
