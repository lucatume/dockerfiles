COMPOSER_VERSION = 1.9.3
CODECEPTION_VERSION = 3.1.0
WPBROWSER_VERSION = 2.2.36
PHPSTAN_VERSION = 0.12
PHPSTAN_WORDPRESS_VERSION = 0.6

build: composer_containers codeception_container wpbrowser_container wpstan_container

push:
	docker push lucatume/composer
	docker push lucatume/codeception
	docker push lucatume/wp-browser
	docker push lucatume/wpstan

composer_php_versions = 5.6 7.0 7.1 7.2 7.3 7.4

$(composer_php_versions): %:
	docker build \
		--build-arg PHP_VERSION=$@ \
		--build-arg COMPOSER_VERSION=${COMPOSER_VERSION} \
		--tag lucatume/composer:php$@-c${COMPOSER_VERSION} \
		--tag lucatume/composer:php$@ \
		containers/composer

composer_containers: $(composer_php_versions)

codeception_container:
	docker build \
		--build-arg CODECEPTION_VERSION=${CODECEPTION_VERSION} \
		--tag lucatume/codeception:cc${CODECEPTION_VERSION} \
		--tag lucatume/codeception \
		containers/codeception

wpbrowser_container:
	docker build \
		--build-arg WPBROWSER_VERSION=${WPBROWSER_VERSION} \
		--tag lucatume/wp-browser:${WPBROWSER_VERSION} \
		--tag lucatume/wp-browser \
		containers/wp-browser

wpstan_container:
	docker build \
		--build-arg PHPSTAN_VERSION=${PHPSTAN_VERSION} \
		--build-arg PHPSTAN_WORDPRESS_VERSION=${PHPSTAN_WORDPRESS_VERSION} \
		--tag lucatume/wpstan:${PHPSTAN_VERSION} \
		--tag lucatume/wpstan \
		containers/wpstan
