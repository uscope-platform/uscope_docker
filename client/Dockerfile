FROM ubuntu:hirsute AS builder

WORKDIR /driver
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get -y install npm openssh-client git


# Download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh git clone git@github.com:filssavi/uscope_react.git .

RUN npm install --global yarn
RUN yarn install --production

RUN yarn run build

FROM nginx

WORKDIR /client

COPY --from=builder /driver/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/certs

COPY certs/uscope_0.crt /etc/nginx/certs/uscope_0.crt
COPY certs/uscope_0.pem /etc/nginx/certs/uscope_0.pem