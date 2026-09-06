FROM debian:bookworm

RUN apt update -y && apt install -y curl php-fpm php-mysql mariadb-client && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && mkdir -p /run/php && \
    sed -i 's|/run/php/php8.2-fpm.sock|9000|' /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/wordpress.sh /wordpress.sh

RUN chmod +x /wordpress.sh

EXPOSE 9000

CMD [ "/wordpress.sh" ]