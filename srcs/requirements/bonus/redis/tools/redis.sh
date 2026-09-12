#!/bin/bash

set -e

sed -i "s|bind 127.0.0.1 -::1|bind 0.0.0.0|" /etc/redis/redis.conf

sed -i "s|protected-mode yes|protected-mode no|" /etc/redis/redis.conf

exec redis-server /etc/redis/redis.conf --daemonize no