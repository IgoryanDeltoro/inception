#!/bin/bash

set -e         

Reset='\033[0m'     
Red='\033[0;31m'         
Green='\033[0;32m'       
Yellow='\033[0;33m'       
Blue='\033[0;34m'       
Purple='\033[0;35m'      

echo -e ${Yellow}Starting WordPress setup...${Reset}

chown -R www-data:www-data /var/www/html 
chmod -R 777 /var/www

ls -la /usr/local/bin/

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

export i=1 max=30

echo -e ${Blue}Going etempt to establish connection...${Reset}

until mysql -h ${WORDPRESS_DB_HOST}          \
            -p ${WORDPRESS_DB_PORT}          \
            -u ${WORDPRESS_DB_USER}          \
            -p$(cat $WORDPRESS_DB_PASSWORD)  \
            -e "SELECT 1" >/dev/null 2>&1;  
do
    sleep 1
    export i=$(($i + 1))
    echo    -e ${Purple}Etempt to reestablish connection...${Reset}
    if [ $i -gt $max ]; then
        echo -e ${Red}Unable to establish connection...${Reset}
        exit 1
    fi
done

if  sudo -u www-data wp core is-installed; then
    echo "WordPress already installed."
else
    echo "WordPress creats user-admin."
    sudo -u www-data wp core install                    \
        --url=${DOMAIN_NAME}                            \
        --title="Inception"                             \
        --admin_user="Achilles"                         \
        --admin_password=$(cat $WORDPRESS_DB_PASSWORD)  \
        --admin_email=bondatchuk1989@gmail.com          \
        --skip-email                                    
fi

if ! sudo -u www-data wp user get ${WORDPRESS_DB_USER} > /dev/null 2>&1; 
then
    sudo -u www-data wp user create             \
    ${WORDPRESS_DB_USER}                        \
    ${WORDPRESS_DB_USER}@gamil.com              \
    --role=editor                               \
    --user_pass=$(cat $WORDPRESS_DB_PASSWORD)   
fi

echo -e ${Green}Connection to the MariaDB seccessfuly established.${Reset}
chmod -R 755 /var/www

touch .wp_ready
echo -e  ${Green}Startin php-fpm process...${Reset}
exec php-fpm8.2 -F #&& touch .wp_ready; chown -R www-data:www-data /var/www/html/.wp_ready

