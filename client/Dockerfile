FROM nginx

WORKDIR /client


ARG NGINX_CONFIG=nginx_prod.conf

COPY build /usr/share/nginx/html
COPY ${NGINX_CONFIG} /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/certs



COPY certs/uscope_0.crt /etc/nginx/certs/uscope_0.crt
COPY certs/uscope_0.pem /etc/nginx/certs/uscope_0.pem