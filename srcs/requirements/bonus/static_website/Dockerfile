FROM debian:bookworm

RUN apt update && apt install -y python3 \
    && mkdir -p /var/www/html

COPY ./src /var/www/html

WORKDIR /var/www/html

CMD ["python3", "-m", "http.server", "3000"]