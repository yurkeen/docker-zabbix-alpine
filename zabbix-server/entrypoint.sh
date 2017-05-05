#!/usr/bin/env sh
#
#
#

ZBX_EXTRA_CONFIG_FILE="/etc/zabbix/zabbix_server_extra.conf"


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
    --db_host=
    --db_port=
    --db_name=
    --db_user=
    --db_password=

EOF
}

function update_config(){
cat << EOF > $ZBX_EXTRA_CONFIG_FILE
DBHost=$DB_HOST
DBPort=$DB_PORT
DBName=$DB_NAME
DBUser=$DB_USER
DBPassword=$DB_PASSWORD
EOF
}

#
#
#

check_args $@

read_args $@

update_config

/usr/sbin/zabbix_server --foreground --config /etc/zabbix/zabbix_server.conf
