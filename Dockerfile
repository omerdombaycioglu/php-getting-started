FROM php:8.2-fpm

# 1. Sistem bağımlılıklarını genişletelim
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip pdo pdo_mysql opcache

# 2. Composer'ı daha güvenilir şekilde kuralım
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

# 3. Önce sadece composer dosyalarını kopyalayalım
COPY composer.json composer.lock ./

# 4. Ortam değişkenlerini ayarlayalım
ENV COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_NO_INTERACTION=1 \
    COMPOSER_ALLOW_SUPERUSER=1

# 5. Composer'ı daha ayrıntılı çalıştıralım
RUN composer diagnose && \
    composer show -v && \
    composer install --no-dev --ignore-platform-reqs --optimize-autoloader -vvv

# 6. Diğer dosyaları kopyalayalım
COPY . .

# 7. İzinleri ayarlayalım
RUN chown -R www-data:www-data /var/www/storage && \
    chmod -R 775 /var/www/storage

EXPOSE 9000
CMD ["php-fpm"]