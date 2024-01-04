FROM php:8.1

LABEL maintainer="ZoomoVN <zoomovn@gmail.com>"

ENV TERM xterm

RUN apt-get update && apt-get install -y \
    libpq-dev \
    libmemcached-dev \
    curl \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    vim \
    zlib1g-dev libicu-dev g++ \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

# Install GD extension separately with additional configuration
RUN docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/

# configure intl
RUN docker-php-ext-configure intl

# Install mongodb, xdebug
RUN pecl install mongodb \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Install extensions using the helper script provided by the base image
RUN apt-get update && apt-get install -y libmcrypt-dev libpq-dev libjpeg-dev libzip-dev \
    && docker-php-ext-install \
    pdo_mysql \
    pdo_pgsql \
    zip

RUN usermod -u 1000 www-data

ADD laravel.ini /usr/local/etc/php/conf.d
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www/laravel

# Default command
CMD ["/usr/bin/supervisord"]
