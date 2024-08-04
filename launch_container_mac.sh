#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)


NAME_IMAGE="jetson_cross_image_$USER"
DOCKER_NAME="jetson_cross_docker_$USER"

# Commit
if [ ! $# -ne 1 ]; then
	if [ "commit" = $1 ]; then
		echo 'Now commiting docker container...'
		docker commit $DOCKER_NAME $NAME_IMAGE:latest
		CONTAINER_ID=$(docker ps -a -f name=$DOCKER_NAME --format "{{.ID}}")
		docker rm $CONTAINER_ID
		exit
	fi
fi

# Stop
if [ ! $# -ne 1 ]; then
    if [ "stop" = $1 ]; then
        CONTAINER_ID=$(docker ps -a -f name=$DOCKER_NAME --format "{{.ID}}")
        docker stop $CONTAINER_ID
        docker rm $CONTAINER_ID -f
        exit 0
    fi
fi

# Delete
if [ ! $# -ne 1 ]; then
    if [ "delete" = $1 ]; then
        echo 'Now deleting docker container...'
        CONTAINER_ID=$(docker ps -a -f name=$DOCKER_NAME --format "{{.ID}}")
        docker stop $CONTAINER_ID
        docker rm $CONTAINER_ID -f
        docker image rm $NAME_IMAGE
        exit 0
    fi
fi

DOCKER_OPT=""
DOCKER_WORK_DIR="/home/${USER}"

## For XWindow
DOCKER_OPT="${DOCKER_OPT} \
        --env=QT_X11_NO_MITSHM=1 \
        --volume=/Users/${USER}:/home/${USER}/host_home:rw \
        --env=DISPLAY=${DISPLAY} \
        -w ${DOCKER_WORK_DIR} \
        -u ${USER} \
        --hostname Docker-`hostname` \
        --add-host Docker-`hostname`:127.0.1.1"

DOCKER_OPT="${DOCKER_OPT} --privileged -it "

## Allow X11 Connection
CONTAINER_ID=$(docker ps -a -f name=$DOCKER_NAME --format "{{.ID}}")
if [ ! "$CONTAINER_ID" ]; then
	docker run ${DOCKER_OPT} \
		--shm-size=4gb \
		--env=TERM=xterm-256color \
		--name=${DOCKER_NAME} \
		$NAME_IMAGE:latest \
		/bin/bash
else
	docker start $CONTAINER_ID
	docker attach $CONTAINER_ID
fi


