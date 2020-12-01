COMPOSER_VERSION = 2.0.7
CODECEPTION_VERSION = 3.1.0
WPBROWSER_VERSION = 2.2.36
PHPSTAN_VERSION = 0.12.53
PHPSTAN_WORDPRESS_VERSION = 0.6.3

lint:
	docker run --rm -v $$(pwd)/containers/codeception:/project replicated/dockerfilelint /project/Dockerfile
	docker run --rm -v $$(pwd)/containers/codeception-php-5.6:/project replicated/dockerfilelint /project/Dockerfile
	docker run --rm -v $$(pwd)/containers/composer:/project replicated/dockerfilelint /project/Dockerfile
	docker run --rm -v $$(pwd)/containers/parallel-lint-56:/project replicated/dockerfilelint /project/Dockerfile
	docker run --rm -v $$(pwd)/containers/wp-browser:/project replicated/dockerfilelint /project/Dockerfile
	docker run --rm -v $$(pwd)/containers/wpstan:/project replicated/dockerfilelint /project/Dockerfile

build: composer_containers codeception_container codeception_56_container wpbrowser_container wpstan_container lint_container

push_composer:
	docker push lucatume/composer

push_codeception:
	docker push lucatume/codeception

push_codeception_56:
	docker push lucatume/codeception-php-5.6

push_wpbrowser:
	docker push lucatume/wp-browser

push_wpstan:
	docker push lucatume/wpstan

push_parallel_lint_56:
	docker push lucatume/parallel-lint-56

push: push_composer push_codeception push_codeception_56 push_wpbrowser push_wpstan push_parallel_lint_56

composer_v1_php_versions = 5.6 7.0 7.1 7.2 7.3 7.4
composer_v2_php_versions = 5.6 7.0 7.1 7.2 7.3 7.4

$(composer_v1_php_versions): %:
	# Build Composer v1.
	docker build \
		--build-arg PHP_VERSION=$@ \
		--build-arg COMPOSER_VERSION=1.10.17 \
		--tag lucatume/composer:php$@-c${COMPOSER_VERSION} \
		--tag lucatume/composer:php$@-composer-v1 \
		--tag lucatume/composer:php$@ \
		containers/composer

$(composer_v2_php_versions): %:
	# Build Composer v2, to avoid breaking back-compat, keep tagging the version 1 as default.
    # lucatume/composer:php"${php_version}-${composer_version}" require $required_packages
	docker build \
		--build-arg PHP_VERSION=$@ \
		--build-arg COMPOSER_VERSION=${COMPOSER_VERSION} \
		--tag lucatume/composer:php$@-c${COMPOSER_VERSION} \
		--tag lucatume/composer:php$@-composer-v2 \
		containers/composer

composer_v1_containers: $(composer_v1_php_versions)
.PHONY: composer_v1_containers

composer_v2_containers: $(composer_v2_php_versions)
.PHONY: composer_v2_containers

composer_containers: composer_v1_containers composer_v2_containers
.PHONY: composer_containers

codeception_container:
	docker build \
		--build-arg CODECEPTION_VERSION=${CODECEPTION_VERSION} \
		--tag lucatume/codeception:cc${CODECEPTION_VERSION} \
		--tag lucatume/codeception \
		containers/codeception

codeception_56_container:
	docker build \
		--build-arg CODECEPTION_VERSION=${CODECEPTION_VERSION} \
		--tag lucatume/codeception-php-5.6:cc${CODECEPTION_VERSION} \
		--tag lucatume/codeception-php-5.6 \
		containers/codeception-php-5.6

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

wpstan_container_pro:
	docker build \
		--build-arg PHPSTAN_VERSION=${PHPSTAN_VERSION} \
		--build-arg PHPSTAN_WORDPRESS_VERSION=${PHPSTAN_WORDPRESS_VERSION} \
		--tag lucatume/wpstan-pr:${PHPSTAN_VERSION} \
		--tag lucatume/wpstan-pro \
		containers/wpstan-pro

lint_container:
	docker build --tag lucatume/parallel-lint-56 containers/parallel-lint-56
