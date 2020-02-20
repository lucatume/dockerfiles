FROM lucatume/codeception

ARG WPBROWSER_VERSION

LABEL maintainer="Luca Tumedei <luca@theaveragedev.com>"

RUN composer global require lucatume/wp-browser:${WPBROWSER_VERSION}

# Install required PHP extensions.
#COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
#RUN install-php-extensions pdo_mysql gd mysqli
