# docker-zabbix-alpine
Docker services based on alpine linux


## Starting services
The command


`docker-compose up -d -f ./docker-compose.yml`

will spin up a Zabbix web UI, mysql server (Percona) and a zabbix server.



The zabbix web UI should be available at your host's IP (or 127.0.0.1) port 80.

## Alerts to Slack

`/usr/share/zabbix/alertscripts/slack/slack-message.sh` is being added to the image now. To send alerts using Slack you'll need:

1. Set environment var `WEBHOOK_URL="https://hooks.slack.com/services/ZQXXXXXXX/YYXXXFFFEEE/skskdjIdjr8dfhfxf` to your Slack Teams' Webhook URL
2. Add new media type 'Slack Message' in *Administration ==> Media Types*:
```
  - Name: Slack Message
  - Type: Scrupt
  - Script name: slack/slack-message.sh
  - Script parameters:
  (1)    --channel={ALERT.SENDTO}
  (2)   {ALERT.MESSAGE}
```

3. Update users with the new media type (*Administration ==> Users ==> username ==> Media ==> Add*). Set the field `Sent to` as a Slack username (`@username` or `#channel`). 
4. Adjust your Zabbix alerting settings in *Configuration ==> Actions*

Please feel free to adjust/enhance.
