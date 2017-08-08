#!/usr/bin/env bash

docker build -t lucatume/test-front .

dgoss run -it lucatume/test-front bash
dgoss run -it -e XDEBUG_REMOTE_HOST=1.2.3.4 lucatume/test-front bash
dgoss run -it -e XDEBUG_REMOTE_PORT=8877 lucatume/test-front bash
dgoss run -it -e XDEBUG_REMOTE_PORT=8877 -e XDEBUG_REMOTE_HOST=1.2.3.4 lucatume/test-front bash
dgoss run -it -e XDEBUG_DISABLE=1 lucatume/test-front bash
dgoss run -it -e XDEBUG_DISABLE=1-e XDEBUG_REMOTE_HOST=1.2.3.4 lucatume/test-front bash
dgoss run -it -e XDEBUG_DISABLE=1-e XDEBUG_REMOTE_PORT=8877 lucatume/test-front bash
dgoss run -it -e XDEBUG_DISABLE=1 -e XDEBUG_REMOTE_PORT=8877 -e XDEBUG_REMOTE_HOST=1.2.3.4 lucatume/test-front bash
dgoss run -it -e OPCACHE_DISABLE=1 lucatume/test-front bash

docker tag lucatume/test-front lucatume/test-front:latest