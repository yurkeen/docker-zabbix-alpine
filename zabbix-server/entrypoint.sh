#!/usr/bin/env sh
#
#
#

ZBX_EXTRA_CONFIG_FILE="/etc/zabbix/zabbix_server_extra.conf"
MY_CNF="/root/.my.cnf"

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

function update_zabbix_config(){
cat << EOF > $ZBX_EXTRA_CONFIG_FILE
DBHost=$DB_HOST
DBPort=$DB_PORT
DBName=$DB_NAME
DBUser=$DB_USER
DBPassword=$DB_PASSWORD
EOF
}

function update_mysql_client_config(){
cat << EOF > $MY_CNF
[client]
host=$DB_HOST
port=$DB_PORT
database=$DB_NAME
user=$DB_USER
password=$DB_PASSWORD
EOF
}


function check_mysql_connectivity(){
while true
do
	if [ $(mysql -e exit) ]; then
          echo "Connected! Proceeding..."
	  break
	else
	  echo "Error: Cannot connect to $DB_HOST:$DB_PORT as $DB_USER. Retrying in 5 sec..."
          sleep 1
	fi
done

}


function check_db_exists(){
CHK_TABLE="users"
SOURCE_DB="zabbix"

CHK_QUERY=$(mysql -e "select COUNT(*) FROM information_schema.tables \
	              WHERE table_schema='${CHK_TABLE}' AND table_name='${SOURCE_DB}';")

if [ $CHK_QUERY -eq 1 ];then
  echo "Database present. Proceeding..."
else
  echo "Database not present."
  return 1
fi

}


function provision_db{

  zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql

}


#
#
#

check_args $@

read_args $@

update_mysql_client_config

check_mysql_connectivity

if [ $(check_db_exists) ]; then
  update_zabbix_config
else
  provision_db && check_db_exists || ( echo "Exiting..." && exit 1)
fi  


/usr/sbin/zabbix_server --foreground --config /etc/zabbix/zabbix_server.conf
