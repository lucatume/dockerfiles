#!/usr/bin/env bash

docker build -t sut .

dgoss run -it sut bash
dgoss run -it -e XDEBUG_REMOTE_HOST=1.2.3.4 sut bash
dgoss run -it -e XDEBUG_REMOTE_PORT=8877 sut bash
dgoss run -it -e XDEBUG_REMOTE_PORT=8877 -e XDEBUG_REMOTE_HOST=1.2.3.4 sut bash
dgoss run -it -e XDEBUG_DISABLE=1 sut bash
dgoss run -it -e XDEBUG_DISABLE=1-e XDEBUG_REMOTE_HOST=1.2.3.4 sut bash
dgoss run -it -e XDEBUG_DISABLE=1-e XDEBUG_REMOTE_PORT=8877 sut bash
dgoss run -it -e XDEBUG_DISABLE=1 -e XDEBUG_REMOTE_PORT=8877 -e XDEBUG_REMOTE_HOST=1.2.3.4 sut bash
dgoss run -it -e OPCACHE_DISABLE=1 sut bash
