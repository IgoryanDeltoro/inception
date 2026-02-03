#!/bin/bash
set -e

Reset='\033[0m'       # Text Reset

Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Creat directories for MySQL service
mkdir -p /var/log/mysql && chmod -R 777 /var/log/mysql
mkdir -p  /var/lib/mysql /var/run/mysqld  /run/mysqld 
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
chmod -R 755 /var/run/mysqld

# Initialize MySQL data directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo -e ${Green}Initializing MySQL...${Reset}
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# Start the server to be ready
echo -e ${Green}Starting temporary MariaDB server for setup...${Reset}
mysqld --skip-networking --socket=/run/mysqld/mysqld.sock --user=mysql & pid="$!"

echo -e ${Green}Waiting for MariaDB to be ready...${Reset}
until mysqladmin --socket=/run/mysqld/mysqld.sock ping > /dev/null 2>&1; do
    echo -e ${Yellow}Sleeping 1 sec...${Reset}
    sleep 1
done
echo -e ${Green}MariaDB is ready.${Reset}

MYSQL_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD")
MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD")
export MYSQL_ROOT_PASSWORD
export MYSQL_PASSWORD

echo -e ${Cyan}MYSQL_ROOT_PASSWORD: ${Yellow} ${MYSQL_ROOT_PASSWORD} ${Reset}
echo -e ${Cyan}MYSQL_PASSWORD: ${Yellow} ${MYSQL_PASSWORD} ${Reset}


# Run setup SQL: create database and users
echo -e ${Yellow}Running setup SQL...${Reset}
mysql -u root << EOF
FLUSH PRIVILEGES;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysql -u root -p${MYSQL_ROOT_PASSWORD}

# Shut down temporary server...
echo -e ${Yellow}Shuting down temporary MariaDB...${Reset} 
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown 2>/dev/null || kill $pid

# Wait for shutdown
wait $pid 2>/dev/null || true

# Start MariaDB (PID 1)  (with networking)
echo -e ${Green}Initialization complete. Starting MariaDB...${Reset}
exec mysqld_safe --user=mysql
