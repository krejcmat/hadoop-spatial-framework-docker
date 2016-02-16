FROM krejcmat/hadoop-base:latest
MAINTAINER krejcmat <matejkrejci@gmail.com>

# move all configuration files into container
ADD files/* /usr/local/  
RUN mv /usr/local/bashrc ~/.bashrc 

#install Hive
RUN wget -P /tmp http://apache.miloslavbrada.cz/hive/hive-1.2.1/apache-hive-1.2.1-bin.tar.gz && \
tar xzf /tmp/apache-hive-1.2.1-bin.tar.gz -C /usr/local && \
rm /tmp/apache-hive-1.2.1-bin.tar.gz && \
mv /usr/local/apache-hive-1.2.1-bin /usr/local/hive && \
mv /usr/local/hive-env.sh /usr/local/hive/conf/hive-env.sh && \
cp -f /usr/local/hive/conf/hive-default.xml.template /usr/local/hive/conf/hive-default.xml
