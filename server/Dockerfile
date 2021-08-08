FROM ubuntu:hirsute AS toolchain_builder

WORKDIR /server

ARG REPOSITORY=git@github.com:uscope-platform

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get -y install gcc cmake git python3 python3-pip libantlr4-runtime4.9 libantlr4-runtime-dev libgtest-dev

# Download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh git clone $REPOSITORY/fCore_toolchain.git .
RUN --mount=type=ssh git clone $REPOSITORY/uscope_server.git uscope_server

RUN mkdir build

WORKDIR /server/build
RUN cmake ..
RUN cmake --build . --parallel 4
RUN cmake --install .

WORKDIR /server


FROM ubuntu:hirsute

WORKDIR /server

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get -y install git python3 python3-pip python3-argon2 python3-psycopg2 libantlr4-runtime4.9 libffi-dev python3-passlib python3-flask-cors python3-flask python3-flask-restful

RUN pip3 install flask_jwt_extended sqlitedict gunicorn sqlalchemy redis


COPY --from=toolchain_builder /usr/bin/fCore_has /usr/bin/fCore_has
COPY --from=toolchain_builder /usr/bin/fCore_cc /usr/bin/fCore_cc

COPY --from=toolchain_builder /server/uscope_server .

RUN key=$(openssl rand -base64 32) && sed -i "s/uScope-key/$key/" flask.cfg
RUN key=$(openssl rand -base64 32) && sed -i "s/uScope-JWT-key/$key/" flask.cfg

ENV USCOPE_DEPLOYMENT_OPTION DOCKER
CMD ["gunicorn", "-c", "gunicorn.py", "wsgi:app"]