FROM debian:bookworm

RUN apt update && apt install -y redis-server
    
COPY ./tools/redis.sh /redis.sh
    
RUN chmod +x /redis.sh

EXPOSE 6379

CMD ["/redis.sh"]