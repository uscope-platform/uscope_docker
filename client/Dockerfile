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

FROM ubuntu:jammy as doc_builder

WORKDIR /

ARG REPOSITORY=git@github.com:uscope-platform

ENV TZ=Europe/Rome
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y install gcc make git python3 python3-pip python3-sphinx
RUN pip install sphinx_rtd_theme sphinxcontrib-httpdomain

# Download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh git clone $REPOSITORY/uscope_doc.git uscope_doc

WORKDIR /uscope_doc

RUN make html

FROM nginx

WORKDIR /client


ARG NGINX_CONFIG=nginx_prod.conf

COPY build /usr/share/nginx/html
COPY ${NGINX_CONFIG} /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/certs

COPY certs/uscope_0.crt /etc/nginx/certs/uscope_0.crt
COPY certs/uscope_0.pem /etc/nginx/certs/uscope_0.pem

COPY --from=doc_builder /uscope_doc/_build/html /usr/share/nginx/html/doc