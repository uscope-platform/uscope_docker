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

RUN apk add alpine-sdk --no-cache cmake openssh argp-standalone

# Download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh git clone $REPOSITORY/uscope_driver.git .

RUN cmake -DCMAKE_BUILD_TYPE=Release ./
RUN cmake --build . --parallel 6


FROM alpine:latest as RUNNER
WORKDIR /driver
RUN apk add --no-cache libstdc++ libgcc
COPY --from=builder /driver/uscope_driver .
CMD ["/driver/uscope_driver"]
