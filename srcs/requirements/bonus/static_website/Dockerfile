FROM debian:bookworm

RUN apt update && apt install -y python3 \
    && mkdir -p /var/www/html

COPY ./index.html /var/www/html/index.html

WORKDIR /var/www/html

CMD ["python3", "-m", "http.server", "3000"]