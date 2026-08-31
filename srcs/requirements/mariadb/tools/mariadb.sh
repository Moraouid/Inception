#!/bin/bash

service mariadb start && sleep 2 

mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat "$MYSQL_PASSWORD_FILE")';"

mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat "$MYSQL_PASSWORD_FILE")';"

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat "$MYSQL_ROOT_PASSWORD_FILE")';"

mysql -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p"$(cat "$MYSQL_ROOT_PASSWORD_FILE")" shutdown

exec mysqld_safe