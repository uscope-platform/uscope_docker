FROM redis:latest

WORKDIR /redis
COPY redis.conf /redis/redis.conf
COPY dump.rdb /redis/dump.rdb

RUN mkdir /var/log/redis
RUN mkdir /var/run/redis
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]