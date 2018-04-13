#!/bin/sh

mkdir -p /mnt/store/log
mkdir -p /mnt/store/log-stable
mkdir -p /tmp/letsencrypt-auto
mkdir -p /etc/letsencrypt/ssl 2> /dev/null

[ -f /etc/letsencrypt/ssl/dhparam.pem ] || openssl dhparam -out /etc/letsencrypt/ssl/dhparam.pem 2048

# bootstrap certbot
[ -d /etc/letsencrypt/live/test.melpa.org ] || certbot certonly \
	--standalone \
	--agree-tos \
	--email dcurtis@gmail.com \
	--expand \
	--non-interactive \
	--rsa-key-size 4096 \
	--force-renewal \
	--expand \
	--staging \
	-d test.melpa.org \
	-d stable-test.melpa.org && first_run=true

nginx -g 'daemon off;' &
nginx_pid=$!

while true; do
	echo "goodnight certbot..."
	# sleep for 1 week
	#sleep 604800
	sleep 30

	echo "refreshing certbot..."
	certbot certonly \
		--webroot \
		--webroot-path /tmp/letsencrypt-auto \
		--agree-tos \
		--email dcurtis@gmail.com \
		--expand \
		--non-interactive \
		--rsa-key-size 4096 \
		--force-renewal \
		--expand \
		--staging \
		-d test.melpa.org \
		-d stable-test.melpa.org

	echo "restarting nginx..."
	kill -HUP $nginx_pid
done
