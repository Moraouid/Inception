FROM debian:bookworm

RUN apt update && apt install -y vsftpd \
    && mkdir -p /var/run/vsftpd/empty

COPY ./conf/vsftpd.conf /etc/vsftpd.conf

COPY ./tools/ftp.sh /ftp.sh

RUN chmod +x /ftp.sh

EXPOSE 21 21100-21110

CMD ["/ftp.sh"]