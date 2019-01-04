FROM php:7.2-fpm-alpine

EXPOSE 8000

RUN apk update && apk upgrade \
    && apk add gcc libxml2 libxslt libcurl libc-dev libxml2-dev libxslt-dev make curl icu-dev zlib-dev git redis autoconf\
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
ENV COMPOSER_VERSION 1.8.0
ENV COMPOSER_INSTALLER_SIG 93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '${COMPOSER_INSTALLER_SIG}') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
    && php -r "unlink('composer-setup.php');" \
    && composer --ansi --version --no-interaction

ADD 60-user.ini /usr/local/etc/php/conf.d/
