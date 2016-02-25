FROM php:5.6-fpm

RUN apt-get update \
    && apt-get install -y apt-utils git
RUN apt-get install -y curl libicu-dev zlib1g-dev redis-server \
    && docker-php-ext-install intl \
    && pecl install redis \
    && pecl install apcu-4.0.10 \
    && pecl install xdebug \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && docker-php-ext-enable apcu \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable xdebug

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN usermod -u 1000 www-data

RUN composer -n global require hirak/prestissimo

ADD 60-user.ini /usr/local/etc/php/conf.d/
