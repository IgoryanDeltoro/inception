#!/bin/bash

set -e         

Reset='\033[0m'     
Red='\033[0;31m'         
Green='\033[0;32m'       
Yellow='\033[0;33m'       
Blue='\033[0;34m'       
Purple='\033[0;35m'      

echo -e ${Yellow}Starting WordPress setup...${Reset}

# Establish ownership rights for www-data
chown -R www-data:www-data /var/www/html 
chmod -R 777 /var/www

# Download and create wordpress if it has not already installed.
if [ ! -f /var/www/html/wp-config.php ]; then
    echo -e ${Red}The WordPress not existed.${Reset}
    echo -e ${Blue}Downloading WP-CLI...${Reset}
    wp --info && sudo -u www-data wp core download
    sudo -u www-data wp config create                   \
        --dbname=$WORDPRESS_DB_NAME                     \
        --dbuser=$WORDPRESS_DB_USER                     \
        --dbpass=$(cat $WORDPRESS_DB_PASSWORD)          \
        --dbhost=$WORDPRESS_DB_HOST                     \
        --force
    echo -e ${Green}WP-CLI download finished.${Reset}
fi

# Create a user as an administrator in database if they do not exist.
if  sudo -u www-data wp --url=${DOMAIN_NAME} core is-installed; then
    echo -e ${Green}"WordPress already installed."${Reset}
else
    echo -e ${Green}Creating user-admin...${Reset}
    sudo -u www-data wp core install                    \
        --url=${DOMAIN_NAME}                            \
        --title="Inception"                             \
        --admin_user="Achilles"                         \
        --admin_password=$(cat $WORDPRESS_DB_PASSWORD)  \
        --admin_email=achilles@gmail.com                \
        --skip-email                                    
fi

# Create a user as an aditor in database if they do not exist.
if ! sudo -u www-data wp user get ${WORDPRESS_DB_USER} > /dev/null 2>&1; 
then
    echo -e ${Green}Creating user as aditor...${Reset}
    sudo -u www-data wp user create                      \
    ${WORDPRESS_DB_USER}                                 \
    ${WORDPRESS_DB_USER}@gamil.com                       \
    --role=editor                                        \
    --user_pass=$(cat $WORDPRESS_DB_PASSWORD)   
fi

chmod -R 755 /var/www

echo -e  ${Green}Startin php-fpm process...${Reset}

# Start process as PID1 in background
exec php-fpm8.2 -F

