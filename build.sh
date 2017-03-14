#!/bin/bash
mkdir build
cd build
git clone https://github.com/cpuguy83/docker-nfs-server.git
cd docker-nfs-server
sed -i '1s/.*/FROM resin\/rpi-raspbian:jessie/' Dockerfile
# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start. 
sed -i '3 i\RUN echo "#!/bin/sh\\nexit 0" > /usr/sbin/policy-rc.d' Dockerfile
#sed -i 's/RUN apt-get update -qq \&\& apt-get install -y nfs-kernel-server runit inotify-tools -qq/RUN apt-get update -qq \&\& apt-get install -y nfs-kernel-server inotify-tools/g' Dockerfile
#sed -i 's/exec runsvdir \/etc\/sv/exec service rpcbind restart \&\& service nfs-kernel-server start/g' nfs_setup.sh
DOCKER_TAG='latest'
if [ -n "$TRAVIS_TAG" ]; then DOCKER_TAG=$TRAVIS_TAG; fi
docker build -t theopenbit/rpi-nfs-server:$DOCKER_TAG .
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
docker push theopenbit/rpi-nfs-server:$DOCKER_TAG
