FROM php:8.2-fpm

# Sistem bağımlılıkları
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install zip pdo pdo_mysql

# Composer kurulumu
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Çalışma dizini
WORKDIR /var/www

# Önce composer dosyalarını kopyala
COPY composer.json composer.lock ./

# Bellek limitini artır ve bağımlılıkları yükle
ENV COMPOSER_MEMORY_LIMIT=-1
RUN composer install --no-dev --ignore-platform-reqs --optimize-autoloader --no-interaction -vvv

# Tüm dosyaları kopyala
COPY . .

# İzinleri ayarla
RUN chown -R www-data:www-data /var/www/storage

EXPOSE 9000
CMD ["php-fpm"]