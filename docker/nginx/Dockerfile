FROM nginx:alpine
RUN apk add --no-cache certbot openssl
COPY default.conf /etc/nginx/conf.d/
COPY ./run.sh /run.sh
RUN chmod +x /run.sh
CMD /run.sh
