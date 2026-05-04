#!/bin/bash
set -e

WP_DIR="/var/www/wordpress.deoriginlabs.com"

# If wp-settings.php missing, volume is empty — copy WordPress files in
if [ ! -f "$WP_DIR/wp-settings.php" ]; then
    echo ">>> WordPress core missing — seeding files into volume..."
    cp -r /var/www/wordpress-source/. "$WP_DIR/"
    chown -R www-data:www-data "$WP_DIR"
    echo ">>> Done."
else
    echo ">>> WordPress already present, skipping copy."
fi

# Start PHP-FPM
service php8.1-fpm start
 
# Start Nginx in foreground (keeps container alive)
nginx -g "daemon off;"

exec "$@"
