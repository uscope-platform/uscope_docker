FROM ubuntu:hirsute AS extension_builder

WORKDIR /server

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get -y install gcc cmake git python3 python3-pip libantlr4-runtime4.9 libantlr4-runtime-dev

# Download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh git clone git@github.com:filssavi/fCore_has.git .
RUN --mount=type=ssh git clone git@github.com:filssavi/uscope_server.git uscope_server

RUN python3 setup.py bdist_wheel


FROM ubuntu:hirsute

WORKDIR /server

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get -y install git python3 python3-pip python3-argon2 python3-psycopg2 libantlr4-runtime4.9 libffi-dev python3-sqlalchemy python3-passlib python3-flask-cors python3-flask python3-flask-restful 

RUN pip3 install flask_jwt_extended sqlitedict gunicorn

COPY --from=extension_builder /server/dist/fCore*.whl .
RUN pip3 install /server/fCore*.whl
RUN rm -r fCore*.whl


COPY --from=extension_builder /server/uscope_server .

ENV USCOPE_DEPLOYMENT_OPTION DOCKER
CMD ["gunicorn", "-c", "gunicorn.py", "wsgi:app"]