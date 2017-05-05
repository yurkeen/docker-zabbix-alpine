FROM alpine:edge

MAINTAINER Yury Evtikhov <yury@evtikhov.info>

RUN apk --quiet --no-cache add zabbix zabbix-setup zabbix-mysql

COPY zabbix_server.conf /etc/zabbix/zabbix_server.conf
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
