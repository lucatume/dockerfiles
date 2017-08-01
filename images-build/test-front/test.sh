#!/usr/bin/env bash

docker build -t test_front .

dgoss run -it test_front bash
dgoss run -it -e XDEBUG_REMOTE_HOST=1.2.3.4 test_front bash
dgoss run -it -e XDEBUG_REMOTE_PORT=8877 test_front bash
dgoss run -it -e XDEBUG_REMOTE_PORT=8877 -e XDEBUG_REMOTE_HOST=1.2.3.4 test_front bash
dgoss run -it -e XDEBUG_DISABLE=1 test_front bash
dgoss run -it -e XDEBUG_DISABLE=1-e XDEBUG_REMOTE_HOST=1.2.3.4 test_front bash
dgoss run -it -e XDEBUG_DISABLE=1-e XDEBUG_REMOTE_PORT=8877 test_front bash
dgoss run -it -e XDEBUG_DISABLE=1 -e XDEBUG_REMOTE_PORT=8877 -e XDEBUG_REMOTE_HOST=1.2.3.4 test_front bash
dgoss run -it -e OPCACHE_DISABLE=1 test_front bash
