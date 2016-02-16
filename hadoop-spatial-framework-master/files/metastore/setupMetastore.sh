#! /bin/bash

service mysql start 
ln -s /usr/share/java/mysql-connector-java.jar $HIVE_HOME/lib/mysql-connector-java.jar
./mysql_secure.sh
./init_db.sh
schematool -dbType mysql -initSchema