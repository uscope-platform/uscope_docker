FROM ubuntu:hirsute AS builder

WORKDIR /driver
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get -y install gcc git python3-pip curl ca-certificates cmake


# Download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh git clone git@github.com:filssavi/uscope_driver.git .

RUN cmake ./
RUN cmake --build . --parallel 6


FROM ubuntu:focal as RUNNER
WORKDIR /driver
COPY --from=builder /driver/uscope_driver .
CMD ["/driver/uscope_driver"]
