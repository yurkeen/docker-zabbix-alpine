# docker-zabbix-alpine
Docker services based on alpine linux


## Starting services
The command


`docker-compose up -d -f ./docker-compose.yml`

will spin up a Zabbix web UI, mysql server (Percona) and a zabbix server.



The zabbix web UI should be available at your host's IP (or 127.0.0.1) port 80.

Please feel free to adjust/enhance.
