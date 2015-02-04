#!/bin/bash
#this is a script to push to docker
DOCKER_TAG_BASE="helloworld_"
DOCKER_USERNAME=$1
DOCKER_PASSWORD=$2
DOCKER_EMAIL=$3
DOCKER_IP=$4
BUILD_NUMBER=$5

sudo docker build -t "helloworld_"$BUILD_NUMBER .
sudo docker tag "helloworld_"$BUILD_NUMBER 96.239.251.10:9000/$DOCKER_USERNAME/"helloworld_"$BUILD_NUMBER
sudo docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD -e $DOCKER_EMAIL $DOCKER_IP
sudo docker push $DOCKER_IP/$DOCKER_USERNAME/"helloworld_"$BUILD_NUMBER
