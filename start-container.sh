#!/bin/bash

# run N slave containers
tag=$1
N=$2
 
echo $N
if [ $# != 2  ]
then
	echo "Set first parametar as image version tag(e.g. 0.1) and second as number of nodes"
	exit 1
fi

# delete old master container and start new master container
sudo docker rm -f master &> /dev/null
echo "start master container..."
sudo docker run -d -t --dns 127.0.0.1 -P --name master -h master.krejcmat.com -w /root krejcmat/hadoop-spatial-framework-master:$tag

# get the IP address of master container
FIRST_IP=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" master)
echo $FIRST_IP

#sudo docker rm -f metastore &> /dev/null
#echo "start metastore container..."
#sudo docker run -d -t --dns 127.0.0.1 -P --name metastore -h metastore.krejcmat.com -e JOIN_IP=$FIRST_IP -e "MYSQL_ROOT_PASSWORD=rootpass" krejcmat/hadoop-spatial-framework-metastore:$tag


# delete old slave containers and start new slave containers
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f slave$i &> /dev/null
	echo "start slave$i container..."
	sudo docker run -d -t --dns 127.0.0.1 -P --name slave$i -h slave$i.krejcmat.com -e JOIN_IP=$FIRST_IP krejcmat/hadoop-spatial-framework-slave:$tag

	((i++))
done 


# create a new Bash session in the master container
sudo docker exec -it master bash
# &> /dev/null