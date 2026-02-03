#!/bin/bash

Reset='\033[0m'       # Text Reset

Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

set -e         

echo -e "${Yellow}Starting WordPress setup...${Reset}"

if [ ! -d /run/php/ ] && [ ! -d /var/run/php/ ]; then
    echo -e "${Red}Creating PHP directories...${Reset}"  
    mkdir -p /run/php
    mkdir -p /var/run/php
fi

if [ ! -f /var/www/html/wp-config.php ] && [ ! -f /var/www/html/index.php ]; then
    echo -e  "${Red}The WordPress not existed.${Reset}"
    echo -e  "${Blue}Downloading...${Reset}"
    wget https://wordpress.org/latest.tar.gz -O /tmp/wp.tar.gz
    tar -xzf /tmp/wp.tar.gz -C /tmp/
    mv /tmp/wordpress/* /var/www/html/
    rm -rf /tmp/wp.tar.gz /tmp/wordpress
    echo -e  "${Green}Download finished.${Reset}"
fi

export WORDPRESS_DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD")

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo -e  "${Green}Startin php-fpm process...${Reset}"
exec php-fpm8.2 -F