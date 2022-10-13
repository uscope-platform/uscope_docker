# Copyright 2021 University of Nottingham Ningbo China
# Author: Filippo Savi <filssavi@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:jammy AS toolchain_builder

WORKDIR /server

ARG REPOSITORY=git@github.com:uscope-platform
ARG N_CORES=8

ENV TZ=Europe/Rome
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y install gcc cmake git python3 python3-pip pkg-config default-jre libgtest-dev uuid-dev libssl-dev

# Download public key for github.com
RUN mkdir -p -m 0602 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh git clone https://github.com/Xilinx/bootgen.git

WORKDIR /server/bootgen

RUN make -j$N_CORES

WORKDIR /server

ARG GIT_USER=uscope-platform
ARG GIT_BRANCH=main

ADD https://api.github.com/repos/$GIT_USER/fCore_toolchain/git/refs/heads/main version.json
RUN --mount=type=ssh git clone $REPOSITORY/fCore_toolchain.git -b $GIT_BRANCH

WORKDIR /server/fCore_toolchain

RUN mkdir build

ARG TOOLCHAIN_BUILD=Release

WORKDIR /server/fCore_toolchain/build
RUN cmake -DCMAKE_BUILD_TYPE=$TOOLCHAIN_BUILD ..
RUN cmake --build . --parallel $N_CORES --target parsers
RUN cmake --build . --parallel $N_CORES --target toolchain
RUN cmake --install .

ADD https://api.github.com/repos/$GIT_USER/fCore_toolchain/git/refs/heads/main version.json
RUN --mount=type=ssh git clone $REPOSITORY/uscope_server.git uscope_server

FROM ubuntu:jammy

WORKDIR /server

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get -y install git python3 python3-pip python3-argon2 python3-psycopg2 libffi-dev python3-passlib python3-flask-cors python3-flask gdbserver\
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install flask_jwt_extended sqlitedict gunicorn sqlalchemy redis flask-restful


COPY --from=toolchain_builder /usr/bin/fCore_has /usr/bin/fCore_has
COPY --from=toolchain_builder /usr/bin/fCore_cc /usr/bin/fCore_cc
COPY --from=toolchain_builder /server/bootgen/bootgen /usr/bin/bootgen

COPY uscope_server .

RUN key_1=$(openssl rand -hex 32) && key_2=$(openssl rand -hex 32) && cat server_config.py | sed -e "s/uScope-key/$key_1/" | sed -e "s/uScope-JWT-key/$key_2/" | tee server_config.py

ENV USCOPE_DEPLOYMENT_OPTION DOCKER
CMD ["gunicorn", "-c", "gunicorn.py", "wsgi:app"]