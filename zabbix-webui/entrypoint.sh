#!/usr/bin/env sh
#
#
#

ZBX_WEB_CONFIG_FILE="/usr/share/webapps/zabbix/conf/zabbix.conf.php"


function check_args(){
# Check arguments
if [ $# -eq 0 ]; then
  printf "Error: Mo arguments specified.\n"
  show_help
  exit 1
fi
}

function read_args(){
# Read arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --zabbix_server_host=*)
      ZBX_SERVER_HOST="${1#*=}"
      ;;
    --zabbix_server_port=*)
      ZBX_SERVER_PORT="${1#*=}"
      ;;
    --db_host=*)
      DB_HOST="${1#*=}"
      ;;
    --db_port=*)
      DB_PORT="${1#*=}"
      ;;
    --db_name=*)
      DB_NAME="${1#*=}"
      ;;
    --db_user=*)
      DB_USER="${1#*=}"
      ;;
    --db_password=*)
      DB_PASSWORD="${1#*=}"
      ;;
    *)
      printf "Error: Invalid argument.\n"
      show_help
      exit 1
  esac
  shift
done
}

function show_help(){
cat << EOF
Available options:
    --zabbix_server_host=
    --zabbix_server_port=
    --db_host=
    --db_port=
    --db_name=
    --db_user=
    --db_password=

EOF
}

function update_php_config(){
cat << EOF > $ZBX_WEB_CONFIG_FILE
<?php
global \$DB;
\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
\$DB['TYPE'] = 'MYSQL';
\$DB['SERVER'] = '$DB_HOST';
\$DB['PORT'] = '$DB_PORT';
\$DB['DATABASE'] = '$DB_NAME';
\$DB['USER'] = '$DB_USER';
\$DB['PASSWORD'] = '$DB_PASSWORD';
\$DB['SCHEMA'] = '';
\$ZBX_SERVER = '$ZBX_SERVER_HOST';
\$ZBX_SERVER_PORT = '$ZBX_SERVER_PORT';
\$ZBX_SERVER_NAME = '';
EOF
}

#
#
#

check_args $@

read_args $@

update_php_config

/usr/sbin/httpd -DFOREGROUND

