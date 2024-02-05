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

FROM ubuntu:mantic 

WORKDIR /server
 
RUN apt update && apt-get install -y build-essential git pkg-config python3 python3-sqlitedict python3-flask-restful gunicorn python3-pip python3-scipy python3-psycopg2 libffi8 python3-passlib python3-flask-cors python3-msgpack python3-flask openssl python3-argon2 python3-gunicorn python3-redis python3-sqlalchemy libssl-dev
RUN pip3 install flask_jwt_extended --break-system-packages

ARG N_CORES=12

RUN --mount=type=ssh git clone https://github.com/Xilinx/bootgen.git

WORKDIR /server/bootgen

RUN make -j$N_CORES
RUN ln /server/bootgen/bootgen /bin/bootgen

WORKDIR /server


COPY fCore_has /usr/bin/fCore_has
COPY fCore_emu /usr/bin/fCore_emu
COPY fCore_cc /usr/bin/fCore_cc
COPY emulator_spec_schema.json /usr/local/etc/fcore_toolchain/emulator_spec_schema.json
COPY compiler_spec_schema.json /usr/local/etc/fcore_toolchain/compiler_spec_schema.json

COPY uscope_server .

RUN key_1=$(openssl rand -hex 32) && key_2=$(openssl rand -hex 32) && cat server_config.py | sed -e "s/uScope-key/$key_1/" | sed -e "s/uScope-JWT-key/$key_2/" | tee server_config.py

ENV USCOPE_DEPLOYMENT_OPTION DOCKER
CMD ["gunicorn", "-c", "gunicorn.py", "wsgi:app"]