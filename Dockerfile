FROM composer:2.6 AS composer
FROM php:8.2-fpm

# Gerekli sistem bağımlılıklarını yükle
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install zip pdo pdo_mysql

# Composer'ı kopyala
COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Önce sadece composer.json ve lock dosyalarını kopyala
COPY composer.json composer.lock ./

# Bağımlılıkları yükle (cache için ayrı aşama)
RUN composer install --no-dev --ignore-platform-reqs --optimize-autoloader --no-interaction

# Tüm dosyaları kopyala
COPY . .

# İzinleri ayarla
RUN chown -R www-data:www-data /var/www/storage

EXPOSE 9000
CMD ["php-fpm"]