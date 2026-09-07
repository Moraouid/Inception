FROM debian:bookworm

RUN apt-get update && apt-get install -y redis-server \
	&& rm -rf /var/lib/apt/lists/*
    
COPY ./tools/redis.sh /redis.sh
    
RUN chmod +x /redis.sh

EXPOSE 6379

CMD ["/redis.sh"]