FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install zip pdo pdo_mysql


COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer


WORKDIR /var/www


COPY composer.json composer.lock ./

ENV COMPOSER_MEMORY_LIMIT=-1
RUN composer install --no-dev --ignore-platform-reqs --optimize-autoloader --no-interaction -vvv

COPY . .


RUN chown -R www-data:www-data /var/www/storage

EXPOSE 9000
CMD ["php-fpm"]