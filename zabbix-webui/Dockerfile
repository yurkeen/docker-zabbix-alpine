FROM alpine:edge

MAINTAINER Yury Evtikhov <yury@evtikhov.info>

RUN apk --quiet --no-cache add zabbix zabbix-webif php7-apache2 \
        php7 php7-gd php7-curl php7-bcmath php7-sockets php7-iconv \
        php7-xmlreader php7-dom php7-ctype php7-gettext php7-common \
        php7-xmlwriter php7-session php7-mbstring php7-mysqli \
        php7-simplexml php7-xml php7-xmlrpc && \
    mkdir -p /run/apache2

COPY zabbix_httpd.conf /etc/apache2/conf.d/ 
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
