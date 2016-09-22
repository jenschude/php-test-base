FROM php:7.0-fpm

RUN apt-get update \
    && apt-get install -y apt-utils \
    && apt-get install -y git curl libicu-dev zlib1g-dev redis-server \
    && apt-get clean \
    && docker-php-ext-install intl \
    && pecl install redis \
    && pecl install apcu \
    && pecl install xdebug \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && docker-php-ext-enable apcu \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable xdebug \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer -n global require hirak/prestissimo \
    && usermod -u 1000 www-data

ADD 60-user.ini /usr/local/etc/php/conf.d/
