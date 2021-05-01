FROM nginx

WORKDIR /client

COPY build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/certs

COPY certs/uscope_0.crt /etc/nginx/certs/uscope_0.crt
COPY certs/uscope_0.pem /etc/nginx/certs/uscope_0.pem