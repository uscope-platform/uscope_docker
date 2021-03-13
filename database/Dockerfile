FROM postgres:latest

WORKDIR /db

USER postgres

COPY setup.sql ./setup.sql
COPY init.sql /docker-entrypoint-initdb.d/init.sql
