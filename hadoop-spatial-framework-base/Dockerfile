FROM krejcmat/hadoop-base:latest
MAINTAINER krejcmat <matejkrejci@gmail.com>

# move all configuration files into container
ADD files/* /usr/local/  
RUN mv /usr/local/bashrc ~/.bashrc 


#install Hive
RUN wget -q -o /dev/null -P /tmp http://apache.miloslavbrada.cz/hive/hive-1.2.1/apache-hive-1.2.1-bin.tar.gz && \
tar xzf /tmp/apache-hive-1.2.1-bin.tar.gz -C /usr/local && \
rm /tmp/apache-hive-1.2.1-bin.tar.gz && \
mv /usr/local/apache-hive-1.2.1-bin /usr/local/hive && \
mv /usr/local/hive-env.sh /usr/local/hive/conf/hive-env.sh && \
cp -f /usr/local/hive/conf/hive-default.xml.template /usr/local/hive/conf/hive-default.xml


#install Derby for sql
#RUN wget -q -o /dev/null -P /tmp http://mirror.hosting90.cz/apache//db/derby/db-derby-10.12.1.1/db-derby-10.12.1.1-bin.tar.gz && \
#tar xzf /tmp/db-derby-10.12.1.1-bin.tar.gz -C /usr/local && \
#rm /tmp/db-derby-10.12.1.1-bin.tar.gz && \
#mv /usr/local/db-derby-10.12.1.1-bin /usr/local/derby && \   
#mkdir /usr/local/derby/data




