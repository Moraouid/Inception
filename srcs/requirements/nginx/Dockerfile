FROM debian:bookworm

RUN apt update -y && apt install nginx -y &&  apt install openssl -y && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=MA/ST=IDF/L=Rabat/O=42/OU=42/CN=sel-abbo.42.fr/UID=sel-abbo"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
