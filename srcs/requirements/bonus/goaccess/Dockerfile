FROM debian:bookworm

RUN apt update && apt install -y goaccess python3

COPY ./tools/goaccess.sh /goaccess.sh

RUN chmod +x /goaccess.sh

CMD ["/goaccess.sh"]