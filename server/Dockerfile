FROM ubuntu:focal
  
WORKDIR /server

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get -y install python3 python3-pip python3-matplotlib python3-psycopg2 libantlr4-runtime4.8 libantlr4-runtime-dev libffi-dev cmake
RUN pip3 install pytest flask passlib sqlitedict flask_cors flask_jwt_extended flask_restful argon2_cffi gunicorn psycopg2 SQLAlchemy 
COPY fCore_has ./fCore_has
RUN cd fCore_has ; python3 setup.py install
RUN rm -r fCore_has
ENV USCOPE_DEPLOYMENT_OPTION DOCKER
CMD ["gunicorn", "-c", "gunicorn.py", "wsgi:app"]
