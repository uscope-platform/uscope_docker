FROM postgres:latest

WORKDIR /db

USER postgres

COPY init.sql /docker-entrypoint-initdb.d/init.sql
