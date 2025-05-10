FROM php:8.2-fpm

# Gerekli sistem bağımlılıkları
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip pdo pdo_mysql opcache

# Composer kurulumu
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Çalışma dizini
WORKDIR /var/www

# Önce composer dosyalarını kopyala
COPY composer.json composer.lock ./

# Bellek limitini artır ve bağımlılıkları yükle
ENV COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_NO_INTERACTION=1

# Composer cache için izinleri ayarla
RUN mkdir -p /tmp/composer && \
    chown -R www-data:www-data /tmp/composer
ENV COMPOSER_CACHE_DIR=/tmp/composer

# Bağımlılıkları yükle
RUN composer install --no-dev --ignore-platform-reqs --optimize-autoloader -vvv

# Tüm dosyaları kopyala
COPY . .

# İzinleri ayarla
RUN chown -R www-data:www-data /var/www/storage && \
    chmod -R 775 /var/www/storage

EXPOSE 9000
CMD ["php-fpm"]