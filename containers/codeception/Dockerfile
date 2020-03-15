ARG CODECEPTION_VERSION

FROM codeception/codeception:${CODECEPTION_VERSION}

LABEL maintainer="Luca Tumedei <luca@theaveragedev.com>"

# Install packages that might turn out to be useful.
RUN apt-get update && \
 	apt-get install -y --no-install-recommends mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Install required PHP extensions.
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions pdo_mysql gd mysqli uopz

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

# Set up the Docker entrypoint script.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# The entypoint script will wait for WordPress database to be available, if the relevant db env vars are set.
# Furthermore the script will redirect the commands to the project codecept binary, if that is available.
ENTRYPOINT ["docker-entrypoint.sh"]
