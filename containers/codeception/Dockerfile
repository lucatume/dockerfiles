ARG CODECEPTION_VERSION

FROM codeception/codeception:${CODECEPTION_VERSION}

LABEL maintainer="Luca Tumedei <luca@theaveragedev.com>"

# Install packages that might turn out to be useful.
RUN apt-get update && \
 	apt-get install -y --no-install-recommends mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Remove the installed XDebug extension to allow installing the version compatible with uopz.
RUN pecl uninstall xdebug

# Install required PHP extensions.
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions pdo_mysql gd mysqli xdebug imagick uopz pcntl

# Create a `docker` user to run the container not as root.
RUN addgroup --gid 1000 docker && \
    adduser --uid 1000 --ingroup docker --home /home/docker --shell /bin/sh --disabled-password --gecos "" docker

# Download and set up the fixuid script.
RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\npaths: [ '/project' ]" > /etc/fixuid/config.yml

# Make the docker user home accessible.
RUN chmod -R a+rwx /home/docker

# Change the ownership of the PHP configuration file to ensure all users will be able to update configs.
RUN chmod -R uga+rw /usr/local/etc/php/conf.d

# Configure php date.timezone.
RUN echo "date.timezone=UTC" >> /usr/local/etc/php/conf.d/docker-php-config.ini

# Set up XDebug.
COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Ensure the uopz extension will respect and run exit and die calls.
RUN echo "uopz.exit=1" >> /usr/local/etc/php/conf.d/docker-php-ext-uopz.ini

# Create a `/cache` directory that is `a+rwx`.
RUN mkdir /cache && chmod a+rwx /cache

# Set up the Docker entrypoint script.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

USER docker:docker
WORKDIR /project

# The entypoint script will wait for WordPress database to be available, if the relevant db env vars are set.
# Furthermore the script will redirect the commands to the project codecept binary, if that is available.
ENTRYPOINT ["docker-entrypoint.sh"]
