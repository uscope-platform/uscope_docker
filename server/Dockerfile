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

# ---- build stage: full toolchain, produces dist/uscope_server.js ----
FROM node:20-alpine AS build

ARG VCPKG_FORCE_SYSTEM_BINARIES=1
WORKDIR /server

COPY code /server

RUN npm install
RUN npm run build

# ---- runtime stage: production dependencies + bundle only ----
FROM node:20-alpine

ARG VCPKG_FORCE_SYSTEM_BINARIES=1
WORKDIR /server

COPY code/package.json /server/
RUN npm install --omit=dev && npm cache clean --force

COPY --from=build /server/dist /server/dist

ARG VERSION=unknown
ENV VERSION=$VERSION
ENV USCOPE_DEPLOYMENT_OPTION=DOCKER
CMD ["node", "--enable-source-maps", "dist/uscope_server.js"]
