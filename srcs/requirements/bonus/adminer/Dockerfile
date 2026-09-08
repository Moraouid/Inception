FROM debian:bookworm

RUN apt update && apt install -y php-mysql php-fpm curl \
    && mkdir -p /var/www/html \
    && curl -sL https://www.adminer.org/latest.php -o /var/www/html/adminer.php \
    && sed -i 's|/run/php/php8.2-fpm.sock|9000|' /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/adminer.sh /adminer.sh

RUN chmod +x /adminer.sh

CMD ["/adminer.sh"]