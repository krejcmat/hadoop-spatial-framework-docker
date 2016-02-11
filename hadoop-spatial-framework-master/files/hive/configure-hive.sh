#! /bin/bash

#configure Hive
$HADOOP_HOME/bin/hadoop fs -mkdir       /tmp
$HADOOP_HOME/bin/hadoop fs -mkdir       /root/hive/warehouse
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /tmp
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /root/hive/warehouse