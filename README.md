A collection of my Docker containers.

## composer

A collection of containers to get [Composer](https://getcomposer.org/), including the [hirak/prestissimo plugin](https://github.com/hirak/prestissimo) for the following PHP versions:

* 5.6
* 7.0
* 7.1
* 7.2
* 7.3
* 7.4

Including the latest Composer version.

### Usage

Update Composer dependencies using a specific PHP version:

```bash
docker pull lucatume/composer:php5.6
docker run --rm -v $(pwd):/project lucatume/composer:php5.6 update
```

## codeception

An extension of the default [Codeception](http://codeception.com/ "Codeception - BDD-style PHP testing.") container with XDebug and a minimal set of  extensions required to run [wp-browser](https://github.com/lucatume/wp-browser "lucatume/wp-browser · GitHub") tests for WordPress.  
The container **does not** contain [wp-browser](https://github.com/lucatume/wp-browser "lucatume/wp-browser · GitHub").

### Usage

Run [Codeception](http://codeception.com/ "Codeception - BDD-style PHP testing.") tests in the project:

```bash
docker pull lucatume/codeception
docker run --rm -v $(pwd):/project lucatume/codeception run acceptance
```
The container **does not contain** all you might need to test your project and is meant to be used as part of a `docker-compose` stack.  
The container **does not include** [wp-browser](https://github.com/lucatume/wp-browser "lucatume/wp-browser · GitHub").  

Below an example `docker-compose` stack using the container:

```yaml
version: "3"

networks:
  test:

services:

  db:
    networks:
      - test
    image: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: password

  wordpress:
    networks:
      - test
    image: wordpress
    depends_on:
      - db
    environment:
      WORDPRESS_DB_NAME: test
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: password
    volumes:
      - ./vendor/wordpress/wordpress:/var/www/html

  chrome:
    networks:
      - test
    image: selenium/standalone-chrome:3.141.59-oxygen

  codeception:
    networks:
      - test
    image: lucatume/codeception
    environment:
      WORDPRESS_DB_NAME: test
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: password
    depends_on:
      - wordpress
      - chrome
    volumes:
    - .:/project
```

If the container is passed the `WORDPRESS_DB_`, or `WP_DB_`, environment variables, then the container will wait for the database located by the credentials to be available before running the command.  
If no WordPress database credentials are passed, or not all of them are defined, then the container will just run the `codecept` command from [Codeception](http://codeception.com/ "Codeception - BDD-style PHP testing.").

## wp-browser

A containerized version of [wp-browser](https://github.com/lucatume/wp-browser "lucatume/wp-browser · GitHub") with a minimal version of PHP extensions.  
Based on the `lucatume/codeception` image.

### Usage

Run [Codeception](http://codeception.com/ "Codeception - BDD-style PHP testing.") tests, with [wp-browser](https://github.com/lucatume/wp-browser "lucatume/wp-browser · GitHub"), in the project:

```bash
docker pull lucatume/wp-browser
docker run --rm -v $(pwd):/project lucatume/wp-browser run acceptance
```
The container **does not contain** all you might need to test your project and is meant to be used as part of a `docker-compose` stack.  

Below an example `docker-compose` stack using the container:

```yaml
version: "3"

networks:
  test:

services:

  db:
    networks:
      - test
    image: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: password

  wordpress:
    networks:
      - test
    image: wordpress
    depends_on:
      - db
    environment:
      WORDPRESS_DB_NAME: test
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: password
    volumes:
      - ./vendor/wordpress/wordpress:/var/www/html

  chrome:
    networks:
      - test
    image: selenium/standalone-chrome:3.141.59-oxygen

  wp-browser:
    networks:
      - test
    image: lucatume/wp-browser
    environment:
      WORDPRESS_DB_NAME: test
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: password
    depends_on:
      - wordpress
      - chrome
    volumes:
    - .:/project
```

If the container is passed the `WORDPRESS_DB_`, or `WP_DB_`, environment variables, then the container will wait for the database located by the credentials to be available before running the command.  
If no WordPress database credentials are passed, or not all of them are defined, then the container will just run the `codecept` command from [Codeception](http://codeception.com/ "Codeception - BDD-style PHP testing.").

Read [wp-browser documentation](https://wpbrowser.wptestkit.com/) for more information.

## wpstan

A container to run [phpstan](https://github.com/phpstan/phpstan) and [phpstan for WordPress](https://github.com/szepeviktor/phpstan-wordpress) on source code.  

### Usage

Run `phpstan` on the source code, maximum level:

```bash
docker pull lucatume/wpstan:latest
docker run --rm -v $(pwd):/project lucatume/wpstan analyze -l max
```

To customize the behavior of `phpstan` create a `phstan.neon.dist` configuration file in the project root directory.  
Here's an example:

```neon
includes:
  - phar://phpstan.phar/conf/bleedingEdge.neon
  # Load it from inside the container.
  - /composer/vendor/szepeviktor/phpstan-wordpress/extension.neon
parameters:
  level: max
  inferPrivatePropertyTypeFromConstructor: true
  reportUnmatchedIgnoredErrors: false
  paths:
    - %currentWorkingDirectory%/src/
  excludes_analyse:
    - %currentWorkingDirectory%/src/some-file.php
  autoload_files:
    - %currentWorkingDirectory%/vendor/autoload.php
    - %currentWorkingDirectory%/some-other-src-file.php
  ignoreErrors:
    # Uses func_get_args()
    - '#^Function add_query_arg invoked with [123] parameters?, 0 required\.$#'
```

## parallel-lint-56

Lint PHP code using parallel linting on PHP 5.6.

### Usage

Lint your project `/src` directory:

```bash
docker run --rm -v $(pwd):/project lucatume/parallel-lint-5.6 --colors /project/src
```
