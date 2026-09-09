FROM debian:bookworm

RUN apt-get update && apt-get install -y goaccess python3 \
    && rm -rf /var/lib/apt/lists/*

COPY ./tools/goaccess.sh /goaccess.sh

RUN chmod +x /goaccess.sh

CMD ["/goaccess.sh"]