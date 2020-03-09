ARG CODECEPTION_CONTAINER_VERSION=latest

FROM lucatume/codeception:${CODECEPTION_CONTAINER_VERSION}

ARG WPBROWSER_VERSION

LABEL maintainer="Luca Tumedei <luca@theaveragedev.com>"

RUN composer global require lucatume/wp-browser:${WPBROWSER_VERSION}
