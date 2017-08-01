#!/usr/bin/env bash

docker build -t lucatume/php-52-xdebug .

dgoss run lucatume/php-52-xdebug 
dgoss run -e XDEBUG_REMOTE_HOST=1.2.3.4 lucatume/php-52-xdebug 
dgoss run -e XDEBUG_REMOTE_PORT=8877 lucatume/php-52-xdebug 
dgoss run -e XDEBUG_REMOTE_PORT=8877 -e XDEBUG_REMOTE_HOST=1.2.3.4 lucatume/php-52-xdebug 
dgoss run -e XDEBUG_DISABLE=1 lucatume/php-52-xdebug 
dgoss run -e XDEBUG_DISABLE=1-e XDEBUG_REMOTE_HOST=1.2.3.4 lucatume/php-52-xdebug 
dgoss run -e XDEBUG_DISABLE=1-e XDEBUG_REMOTE_PORT=8877 lucatume/php-52-xdebug 
dgoss run -e XDEBUG_DISABLE=1 -e XDEBUG_REMOTE_PORT=8877 -e XDEBUG_REMOTE_HOST=1.2.3.4 lucatume/php-52-xdebug 
dgoss run -e OPCACHE_DISABLE=1 lucatume/php-52-xdebug 
dgoss run -e MEMCACHE_DISABLE=1 lucatume/php-52-xdebug 
