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

FROM alpine:latest AS builder

ARG REPOSITORY=https://github.com/uscope-platform

WORKDIR /driver

RUN apk add alpine-sdk --no-cache cmake openssh argp-standalone python3 py3-pip bash
RUN pip install conan

# Download public key for github.com
ARG GIT_USER=uscope-platform

RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
ADD https://api.github.com/repos/$GIT_USER/uscope_driver/git/refs/heads/main version.json
RUN --mount=type=ssh git clone $REPOSITORY/uscope_driver.git

WORKDIR /driver/uscope_driver


RUN conan profile detect --force

RUN cmake . -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=cmake-conan/conan_provider.cmake -DCMAKE_BUILD_TYPE=Release -DEXCLUDE_KERNEL_EMU=TRUE
RUN cmake --build . --parallel $N_CORES
RUN cmake --install .


FROM alpine:latest as RUNNER
WORKDIR /driver
RUN apk add --no-cache libstdc++ libgcc
COPY --from=builder /driver/uscope_driver .
CMD ["/driver/uscope_driver"]
