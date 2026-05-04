# ================================
# WordPress + PHP-FPM + Nginx
# ================================
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Add ondrej/php PPA for PHP packages
# Install system dependencies + Nginx + Supervisor
RUN apt-get update && apt-get install -y \
        software-properties-common \
        nano \
        nginx \
        php8.1-fpm \
        php8.1-mysql \
        php8.1-curl \
        php8.1-gd \
        php8.1-mbstring \
        php8.1-xml \
        php8.1-zip \
        php8.1-intl \
        php8.1-opcache \
        curl \
        unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# Download WordPress core directly into /var/www/html
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /tmp \
    && mkdir -p /var/www/wordpress-source && cp -r /tmp/wordpress/. /var/www/wordpress-source/ \
    && rm -rf /tmp/wordpress /tmp/wordpress.tar.gz

# PHP config
COPY nginx/php.ini /usr/local/etc/php/conf.d/custom.ini

# Nginx config
RUN rm -f /etc/nginx/sites-enabled/default
COPY nginx/nginx.conf    /etc/nginx/nginx.conf
COPY nginx/wordpress.deoriginlabs.conf    /etc/nginx/sites-enabled/wordpress.deoriginlabs.conf

# Nginx sites-enabled dir
RUN mkdir -p /etc/nginx/sites-enabled

# Permissions
RUN chown -R www-data:www-data /var/www/wordpress-source \
    && find /var/www/wordpress-source -type d -exec chmod 755 {} \; \
    && find /var/www/wordpress-source -type f -exec chmod 644 {} \;

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
