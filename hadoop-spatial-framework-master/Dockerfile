FROM krejcmat/hadoop-spatial-framework-base:latest
MAINTAINER krejcmat <matejkrejci@gmail.com>

# move all confugration files into container
ADD files/hadoop/* /tmp/
ADD files/hive/* /tmp/
ADD files/metastore/* /tmp/
ADD files/init/* /tmp/

ENV HADOOP_INSTALL /usr/local/hadoop

RUN mkdir -p ~/hdfs/namenode && \
mkdir -p ~/hdfs/datanode

RUN mv /tmp/hdfs-site.xml $HADOOP_INSTALL/etc/hadoop/hdfs-site.xml && \ 
mv /tmp/core-site.xml $HADOOP_INSTALL/etc/hadoop/core-site.xml && \
mv /tmp/mapred-site.xml $HADOOP_INSTALL/etc/hadoop/mapred-site.xml && \
mv /tmp/yarn-site.xml $HADOOP_INSTALL/etc/hadoop/yarn-site.xml && \
mv /tmp/stop-hadoop.sh ~/stop-hadoop.sh && \
mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \ 
mv /tmp/configure-members.sh ~/configure-members.sh && \
mv /tmp/configure-hive.sh ~/configure-hive.sh && \
mv /tmp/hive-config.sh /usr/local/bin/hive-config.sh && \
mv /tmp/hive-site.xml /usr/local/hive/conf/hive-siteXXX.xml && \
mv /tmp/start-ssh-serf.sh ~/start-ssh-serf.sh && \ 
mv /tmp/.my.cnf ~/.my.cnf && \ 
mv /tmp/mysql_secure.sh ~/mysql_secure.sh && \
mv /tmp/setupMetastore.sh ~/setupMetastore.sh && \
mv /tmp/init_db.sh ~/init_db.sh


RUN chmod +x ~/start-hadoop.sh && \
chmod +x ~/stop-hadoop.sh && \
chmod +x ~/run-wordcount.sh && \
chmod +x ~/configure-members.sh && \
chmod +x ~/mysql_secure.sh && \
chmod +x ~/start-ssh-serf.sh && \
chmod +x ~/configure-hive.sh && \
chmod +x ~/start-ssh-serf.sh && \ 
chmod +x ~/init_db.sh && \ 
chmod +x ~/setupMetastore.sh && \ 
chmod 0600 ~/.my.cnf && \
chmod 1777 tmp

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

EXPOSE 22 7373 7946 9000 50010 50020 50070 50075 50090 50475 8030 8031 8032 8033 8040 8042 8060 8088 50060

RUN apt-get install git -y && apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y &&\
rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN wget -q -o out.log -P /tmp http://apache.miloslavbrada.cz/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
tar xzf /tmp/apache-maven-3.3.9-bin.tar.gz -C /usr/local && \
rm /tmp/apache-maven-3.3.9-bin.tar.gz && \
mv /usr/local/apache-maven-3.3.9 /usr/local/maven

ENV PATH $PATH:/usr/local/maven/bin

RUN git clone https://github.com/Esri/geometry-api-java.git /usr/local/geometry-api-java  && \
cd /usr/local/geometry-api-java && \
mvn clean install 

RUN git clone https://github.com/Esri/spatial-framework-for-hadoop.git /usr/local/spatial-framework-for-hadoop && \
cd /usr/local/spatial-framework-for-hadoop && \
mvn clean package -DskipTests 

RUN wget -q -o out.log -P /usr/local/ https://github.com/sheetaldolas/Hive-JSON-Serde/archive/json-serde-1.1.9.8.zip && \
unzip /usr/local/json-serde-1.1.9.8.zip -d /usr/local/ && \
rm /usr/local/json-serde-1.1.9.8.zip  

CMD '/root/start-ssh-serf.sh'; 'bash'

###instalation without prompt  
##see $ debconf-get-selections | grep mysql-server
RUN apt-get install debconf-utils -y  && \
echo "mysql-server-5.5 mysql-server/root_password_again password rootpass" | debconf-set-selections && \
echo "mysql-server-5.5 mysql-server/root_password password rootpass" | debconf-set-selections && \
apt-get install -y  mysql-server-5.5 && \
apt-get install -y libmysql-java && \
apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
rm -rf /var/lib/{apt,dpkg,cache,log}/ 

#RUN ln -s /usr/share/java/libmysql-java.jar /usr/local/hive/lib/libmysql-java.jar
#RUN ln -s /usr/share/java/mysql-connector-java.jar $HIVE_HOME/lib/mysql-connector-java.jar

#init db metastore
#RUN service mysql start
#RUN bash /tmp/mysql_secure.sh
#RUN bash /tmp/init_db.sh
#RUN schematool -dbType mysql -initSchema


