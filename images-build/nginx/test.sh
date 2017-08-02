#!/usr/bin/env bash

# pull a PHP container to allow Ngnix to run
docker pull php:7.1-fpm-alpine

# spin up the required PHP container
docker run --name test_support_php -v $(pwd)/tests/app:/var/www/html --rm -d php:7.1-fpm-alpine

docker build -t lucatume/nginx-for-wp .

dgoss run --link test_support_php:php -v $(pwd)/tests/app:/var/www/html -p 8080:80 lucatume/nginx-for-wp 
dgoss run --link test_support_php:php -v $(pwd)/tests/app:/var/www/html -e DOMAIN=foo.bar -p 8080:80 lucatume/nginx-for-wp 
dgoss run --link test_support_php:php -v $(pwd)/tests/app:/var/www/html -e DOMAIN=localhost:8080 -p 8080:80 lucatume/nginx-for-wp 
