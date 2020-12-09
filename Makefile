COMPOSER_V1_VERSION = 1.10.17
COMPOSER_V2_VERSION = 2.0.7
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

lorem:
	echo 'lorem';

push_composer:
	docker images --format "{{.Repository}}:{{.Tag}}"  | grep lucatume/composer | xargs -n 1 docker push

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

composer_php_versions = 5.6 7.0 7.1 7.2 7.3 7.4 8.0
$(composer_php_versions): %:
	# Build for Composer version 1, keep this as default.
	docker build \
		--build-arg PHP_VERSION=$@ \
		--build-arg COMPOSER_VERSION=${COMPOSER_V1_VERSION} \
		--tag lucatume/composer:php$@-composer-v${COMPOSER_V1_VERSION} \
		--tag lucatume/composer:php$@-composer-v1 \
		--tag lucatume/composer:php$@ \
		containers/composer
	# Build for Composer version 2.
	docker build \
		--build-arg PHP_VERSION=$@ \
		--build-arg COMPOSER_VERSION=${COMPOSER_V2_VERSION} \
		--tag lucatume/composer:php$@-composer-v${COMPOSER_V2_VERSION} \
		--tag lucatume/composer:php$@-composer-v2 \
		containers/composer

composer_containers: $(composer_php_versions)
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
