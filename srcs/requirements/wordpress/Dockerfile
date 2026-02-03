FROM debian:bookworm 

RUN apt-get update &&                                       \
    apt-get install -y                                      \
    php8.2                                                  \
    php8.2-fpm                                              \
    php8.2-mysql                                            \
    php8.2-xml                                              \
    php8.2-zip                                              \
    php8.2-curl                                             \
    php8.2-mbstring                                         \
    php8.2-gd                                               \
    wget                                                    \
    mariadb-client &&                                       \
    ln -s /usr/sbin/php-fpm8.2 /usr/local/bin/php-fpm &&    \
    rm -rf /var/lib/apt/lists/* 

RUN mkdir -p /run/php /var/run/php

COPY /tools/wp-install.sh /wp-install.sh

RUN chmod +x wp-install.sh

RUN sed -i 's@listen = \/run\/php\/php8.2-fpm.sock@listen = 9000@g' \
    /etc/php/8.2/fpm/pool.d/www.conf

EXPOSE 9000

WORKDIR /var/www/html

CMD ["/wp-install.sh"]