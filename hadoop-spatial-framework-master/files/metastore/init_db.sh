#!/bin/bash


MYSQL=`which mysql`
$MYSQL  -e "create database metastore;"
$MYSQL -u root -e "CREATE USER root IDENTIFIED BY 'rootpass';"
#$MYSQL -u root -e "REVOKE ALL PRIVILEGES, GRANT OPTION FROM root@master.krejcmat.com;"
$MYSQL -u root -e "GRANT ALL ON *.* TO root@localhost  identified by 'rootpass';"
$MYSQL -u root -e "USE metastore"
$MYSQL -u root -e "FLUSH PRIVILEGES;"
echo "done"

