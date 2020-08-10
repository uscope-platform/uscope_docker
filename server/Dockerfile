FROM ubuntu:focal

WORKDIR /server

RUN apt-get update && apt-get -y install redis python3 python3-pip 
RUN pip3 install pytest redis flask passlib numpy sqlitedict flask_cors flask_jwt_extended flask_restful argon2_cffi
CMD ["python3", "debug_main.py"]

