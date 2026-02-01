#!/bin/bash
set -e

# Read secrets
export MYSQL_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD")
export MYSQL_USER_PASSWORD=$(cat "$MYSQL_USER_PASSWORD")

mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
chmod 755 /var/run/mysqld

# Initialize MySQL data directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# Start MariaDB (PID 1)
exec mysqld --user=mysql
