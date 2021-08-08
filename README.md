# uScope Platform docker infrastructure

To ease development and deployment the software components are containerized through docker, this repository contains the Dockerfiles and relevant necessary configuration files.

## Containers

- **Client**: Nginx web server used to serve static files and to terminate the TLS session, reverse proxying the REST api requests to other components

- **Server**: Python REST Server implementing the rest API that acts as a backend for the web application

- **Database**: Postgres database used for persitence of all user data

- **Driver**: Low level C++ driver that talks through the custom kernel module to the hardware implementing all necessary binary and bitwise operations

## Docker compose configurations

The Container orchestration is done through the docker-compose system. Two configurations are present:

- docker-compose_devel.yml:  This configuration can be used for component development and debug, with everything running on a regular workstation. Driver, Server Databases are run in docker, while server and client are run locally to the development environment to allow the use of debuggers. The hardware is emulated at the driver level.

- docker-compose_staging.yml: This configuration can be used for integration testing, training, and infrastructure development, everything is run on a regular workstation. Everything is run in the proper docker containers, however for convenience TLS is not used. The hardware is emulated at the driver level

- docker-compose_zed.yml: This configuration is the one that gets deployed on production hardware

Docker compose can not generate the required containers for the staging or production configurations, consequently the respective ansible playbooks should be used
