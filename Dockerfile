FROM php:7.4-fpm-alpine

EXPOSE 8000

RUN apk update && apk upgrade \
    && apk add gcc libxml2 libxslt libcurl libc-dev libxml2-dev libxslt-dev make curl icu-dev zlib-dev libzip-dev oniguruma-dev git redis autoconf\
    && docker-php-ext-install intl \
    && pecl install redis \
    && pecl install apcu \
    && pecl install xdebug \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && docker-php-ext-enable apcu \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable xdebug \
    && apk del gcc libxml2-dev libxslt-dev make \
    && rm -rf /var/cache/apk/*

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV COMPOSER_VERSION 2.1.3
ENV COMPOSER_INSTALLER_SIG 756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '${COMPOSER_INSTALLER_SIG}') { echo 'Installer verified' . PHP_EOL; exit(0); } else { echo 'Installer corrupt' . PHP_EOL; unlink('composer-setup.php'); exit(1); }" \
    && php composer-setup.php --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
    && php -r "unlink('composer-setup.php');" \
    && composer --ansi --version --no-interaction

ADD 60-user.ini /usr/local/etc/php/conf.d/
