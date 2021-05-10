# uScope Platform docker infrastructure

To ease development and deployment the software components are containerized through docker, this repository contains the Dockerfiles and relevant necessary configuration files.

## Containers

- **Client**: Nginx web server used to serve static files and to terminate the TLS session, reverse proxying the REST api requests to other components

- **Server**: Python REST Server implementing the rest API that acts as a backend for the web application

- **Database**: Postgres database used for persitence of all user data

- **Driver**: Low level C++ driver that talks through the custom kernel module to the hardware implementing all necessary binary and bitwise operations

## Docker compose

The Container orchestration is done through the docker-compose system. Two configurations are present:

- docker-compose.yml: used for development and debug on a regular PC, where the hardware is emulated at the driver level

- docker-compose_zed.yml: used on hardware in deployed systems.