# Doc: https://hub.docker.com/_/php/
FROM php:8.4.3-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    zip \
    libzip-dev \
    && docker-php-ext-configure gd \
    && docker-php-ext-install gd zip

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Use our minimal custom php conf to support some legacy behavior.
COPY 99-custom-php.ini "$PHP_INI_DIR/conf.d"

COPY . /var/www/html/

# Grant write permissions to /var/www/html to www-data, because
# the application writes temporary files to /var/www/html/generated/
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Enable logs specified in log4php.xml
RUN mkdir -p /home/vdl/logs/android-holo-colors
RUN chown -R www-data:www-data /home/vdl/logs && chmod -R 775 /home/vdl/logs

EXPOSE 80

