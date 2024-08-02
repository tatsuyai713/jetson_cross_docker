#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)


NAME_IMAGE="jetson_cross_image_$USER"

# Delete
echo 'Now deleting docker container...'
CONTAINER_ID=$(docker ps -a | grep ${DOCKER_NAME} | awk '{print $1}')
docker stop $CONTAINER_ID
docker rm $CONTAINER_ID -f
docker image rm ${NAME_IMAGE}
