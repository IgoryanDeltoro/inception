#!/bin/bash

set -e         

Reset='\033[0m'     
Red='\033[0;31m'         
Green='\033[0;32m'       
Yellow='\033[0;33m'       
Blue='\033[0;34m'       
Purple='\033[0;35m'      

echo -e ${Yellow}Starting WordPress setup...${Reset}

if [ ! -d /run/php/ ] && [ ! -d /var/run/php/ ]; then
    echo  -e ${Red}Creating PHP directories...${Reset} 
    mkdir -p /run/php
    mkdir -p /var/run/php
fi

if [ ! -f /var/www/html/wp-config.php ] && [ ! -f /var/www/html/index.php ]; then
    echo -e     ${Red}The WordPress not existed.${Reset}
    echo -e     ${Blue}Downloading...${Reset}
    wget        https://wordpress.org/latest.tar.gz >/dev/null 2>&1 -O /tmp/wp.tar.gz
    tar  -xzf   /tmp/wp.tar.gz -C /tmp/
    mv          /tmp/wordpress/* /var/www/html/
    rm   -rf    /tmp/wp.tar.gz /tmp/wordpress
    echo -e     ${Green}Download finished.${Reset}
fi

export i=1 max=30

echo -e ${Blue}Going etempt to establish connection...${Reset}

until mysql -h ${WORDPRESS_DB_HOST}          \
            -p ${WORDPRESS_DB_PORT}          \
            -u ${WORDPRESS_DB_USER}          \
            -p$(cat $WORDPRESS_DB_PASSWORD)  \
            -e "SELECT 1" >/dev/null 2>&1;  do
    sleep 1
    export i=$(($i + 1))
    echo    -e ${Purple}Etempt to reestablish connection...${Reset}
    if [ $i -gt $max ]; then
        echo -e ${Red}Unable to establish connection...${Reset}
        exit 1
    fi
done

echo -e ${Green}Connection to the MariaDB seccessfuly established.${Reset}

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo -e  ${Green}Startin php-fpm process...${Reset}
exec php-fpm8.2 -F