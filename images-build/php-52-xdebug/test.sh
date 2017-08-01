#!/usr/bin/env bash

docker build -t php52 .

dgoss run php52 
dgoss run -e XDEBUG_REMOTE_HOST=1.2.3.4 php52 
dgoss run -e XDEBUG_REMOTE_PORT=8877 php52 
dgoss run -e XDEBUG_REMOTE_PORT=8877 -e XDEBUG_REMOTE_HOST=1.2.3.4 php52 
dgoss run -e XDEBUG_DISABLE=1 php52 
dgoss run -e XDEBUG_DISABLE=1-e XDEBUG_REMOTE_HOST=1.2.3.4 php52 
dgoss run -e XDEBUG_DISABLE=1-e XDEBUG_REMOTE_PORT=8877 php52 
dgoss run -e XDEBUG_DISABLE=1 -e XDEBUG_REMOTE_PORT=8877 -e XDEBUG_REMOTE_HOST=1.2.3.4 php52 
dgoss run -e OPCACHE_DISABLE=1 php52 
dgoss run -e MEMCACHE_DISABLE=1 php52 
