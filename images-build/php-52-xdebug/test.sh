#!/usr/bin/env bash

docker build -t sut .

dgoss run sut
dgoss run -e XDEBUG_REMOTE_HOST=1.2.3.4 sut
dgoss run -e XDEBUG_REMOTE_PORT=8877 sut
dgoss run -e XDEBUG_REMOTE_PORT=8877 -e XDEBUG_REMOTE_HOST=1.2.3.4 sut