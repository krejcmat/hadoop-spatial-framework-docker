#!/bin/bash

image=$1
tag='latest'


if [ $1 = 0 ]
then
	echo "Please use image name as the first argument!"
	exit 1
fi

# founction for delete images
function docker_rmi()
{
	echo -e "\n\nsudo docker rmi krejcmat/$1:$tag"
	sudo docker rmi krejcmat/$1:$tag
}


# founction for build images
function docker_build()
{
	cd $1
	echo -e "\n\nsudo docker build -t krejcmat/$1:$tag ."
	/usr/bin/time -f "real  %e" sudo docker build -t krejcmat/$1:$tag .
	cd ..
}

#echo -e "\ndocker rm -f slave1 slave2 master"
#sudo docker rm -f slave1_spatial-framework slave2 master

sudo docker images >images.txt

#all image is based on dnsmasq. master and slaves are based on base image.

if [ $image == "hadoop-spatial-framework-base" ]
then
	docker_rmi hadoop-spatial-framework-master
	docker_rmi hadoop-spatial-framework-slave
	docker_rmi hadoop-spatial-framework-base
	#docker_rmi hadoop-spatial-framework-metastore
	docker_build hadoop-spatial-framework-base
	docker_build hadoop-spatial-framework-master
	docker_build hadoop-spatial-framework-slave
	#docker_build hadoop-spatial-framework-metastore
elif [ $image == "hadoop-spatial-framework-master" ]
then
	docker_rmi hadoop-spatial-framework-master
	docker_build hadoop-spatial-framework-master
elif [ $image == "hadoop-spatial-framework-slave" ]
then
	docker_rmi hadoop-spatial-framework-slave
	docker_build hadoop-spatial-framework-slave
#elif [ $image == "hadoop-spatial-framework-metastore" ]
#then
#	docker_rmi hadoop-spatial-framework-metastore
#	docker_build hadoop-spatial-framework-metastore
else
	echo "The image name is wrong!"
fi

#docker_rmi hadoop-spatial-framework-base

echo -e "\nimages before build"
cat images.txt
rm images.txt

echo -e "\nimages after build"
sudo docker images
