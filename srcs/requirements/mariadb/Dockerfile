FROM debian:bookworm

RUN apt-get update &&   \
    apt-get install -y  \
    mariadb-server      \
    mariadb-client      \
    galera-4 &&         \
    rm -fr /var/lib/apt/lists/*
   
COPY /conf/50-server.cnf /etc/mysql/mariadb.conf.d
# RUN rm -rf /etc/mysql/my.cnf

COPY /tools/init-db.sh /usr/local/bin/init-db.sh

RUN chmod +x /usr/local/bin/init-db.sh

EXPOSE 3306

ENTRYPOINT [ "init-db.sh" ]