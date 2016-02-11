FROM krejcmat/hadoop-spatial-framework-base:latest
MAINTAINER krejcmat <matejkrejci@gmail.com>

# move all confugration files into container
ADD files/hadoop/* /tmp/
ADD files/hive/* /tmp/

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
mv /tmp/start-ssh-serf.sh ~/start-ssh-serf.sh && \ 
mv /tmp/configure-members.sh ~/configure-members.sh && \
mv /tmp/configure-hive.sh ~/configure-hive.sh && \
mv /tmp/hive-config.sh /usr/local/bin/hive-config.sh 

#mv /tmp/hive-site.xml /usr/local/hive/conf/hive-site.xml

RUN chmod +x ~/start-hadoop.sh && \
chmod +x ~/run-wordcount.sh && \
chmod +x ~/start-ssh-serf.sh && \
chmod 1777 tmp

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

EXPOSE 22 7373 7946 9000 50010 50020 50070 50075 50090 50475 8030 8031 8032 8033 8040 8042 8060 8088 50060

CMD '/root/start-ssh-serf.sh'; 'bash'


RUN apt-get install git -y && apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y &&\
rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN wget -q -o /dev/null -P /tmp http://apache.miloslavbrada.cz/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
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

RUN wget -q -o /dev/null -P /usr/local/ https://github.com/sheetaldolas/Hive-JSON-Serde/archive/json-serde-1.1.9.8.zip && \
unzip /usr/local/json-serde-1.1.9.8.zip -d /usr/local/ && \
rm /usr/local/json-serde-1.1.9.8.zip  

