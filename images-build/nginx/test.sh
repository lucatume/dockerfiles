#!/usr/bin/env bash

# pull a PHP container to allow Ngnix to run
docker pull php:7.1-fpm-alpine

# spin up the required PHP container
function stop_support_container(){
    running="$(docker ps -aq --filter="name=test_support_php")"
    if [[ $running != "" ]]; then
        docker stop $running
    fi
}

function start_support_container(){
    stop_support_container
    docker run --name test_support_php --rm -d php:7.1-fpm-alpine
}

docker build -t sut .

start_support_container
dgoss run --link test_support_php:php -p 8080:80 sut
dgoss run --link test_support_php:php -e HOST=foo.bar -p 8080:80 sut
dgoss run --link test_support_php:php -e HOST=localhost:8080 -p 8080:80 sut
stop_support_container