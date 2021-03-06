FROM 1and1internet/ubuntu-18
MAINTAINER brian.wilkinson@1and1.co.uk
ARG DEBIAN_FRONTEND=noninteractive
COPY files /

ENV HOMEDIR=/var/www
ENV PASSENGER_APP_ENV=production \
	SSL_KEY=/ssl/ssl.key \
	SSL_CERT=/ssl/ssl.crt \
	VIRTENV=${HOMEDIR}/._venv
ENV PATH ${VIRTENV}/bin:$PATH

RUN \
	apt-get update -q && \
	apt-get install -q -o Dpkg::Options::=--force-confdef -y \
			apt-transport-https ca-certificates nginx \
			ssl-cert sqlite3 libmysqlclient-dev mysql-common \
			build-essential libssl-dev python3-dev python3 python3-venv \
			libpcre3 libpcre3-dev && \
	apt-get autoremove -q -y && \
	apt-get clean -q -y && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/www/html && \
	rm -rf /var/www && \
	mkdir -p /var/www && \
	chmod -R 777 /var/www /var/log/nginx /var/lib/nginx && \
	chmod -R 755 /hooks /init /etc/ssl/private && \
	chmod 777 /etc/passwd /etc/group /etc && \
	touch /var/log/nginx/access.log /var/log/nginx/error.log && \
	chmod -R 777 /var/log/nginx/ && \
	echo "" >> /etc/nginx/nginx.conf && \
	echo "daemon off;" >> /etc/nginx/nginx.conf && \
	mkdir -p /etc/nginx/main.d/ && \
	sed -i -e 's|http {|include /etc/nginx/main.d/*;\nhttp {|' /etc/nginx/nginx.conf && \
	sed -i -r -e '/^user www-data;/d' /etc/nginx/nginx.conf && \
	sed -i -e '/sendfile on;/a\        client_max_body_size 0\;' /etc/nginx/nginx.conf && \
	chmod -R 777 /etc/nginx/sites-enabled
EXPOSE 8080 8443
WORKDIR ${HOMEDIR}
