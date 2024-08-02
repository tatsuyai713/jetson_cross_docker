#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)


NAME_IMAGE="jetson_cross_image_$USER"

# Commit
if [ ! $# -ne 1 ]; then
	if [ "commit" = $1 ]; then
		echo 'Now commiting docker container...'
		docker commit jetson_cross_docker $NAME_IMAGE:latest
		CONTAINER_ID=$(docker ps -a -f name=jetson_cross_docker --format "{{.ID}}")
		docker rm $CONTAINER_ID
		exit
	fi
fi

XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
if [ ! -z "$xauth_list" ];  then
  echo $xauth_list | xauth -f $XAUTH nmerge -
fi
chmod a+r $XAUTH

DOCKER_OPT=""
DOCKER_NAME="jetson_cross_docker"
DOCKER_WORK_DIR="/home/${USER}"

## For XWindow
DOCKER_OPT="${DOCKER_OPT} \
        --env=QT_X11_NO_MITSHM=1 \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw \
        --volume=/home/${USER}:/home/${USER}/host_home:rw \
        --env=XAUTHORITY=${XAUTH} \
        --volume=${XAUTH}:${XAUTH} \
        --env=DISPLAY=${DISPLAY} \
        -w ${DOCKER_WORK_DIR} \
        -u ${USER} \
        --hostname `hostname`-Docker \
        --add-host `hostname`-Docker:127.0.1.1"

# For nvidia-docker
DOCKER_OPT="${DOCKER_OPT} --runtime=nvidia  --gpus all "
DOCKER_OPT="${DOCKER_OPT} --privileged -it "

## Allow X11 Connection
xhost +local:`hostname`-Docker
CONTAINER_ID=$(docker ps -a -f name=jetson_cross_docker --format "{{.ID}}")
if [ ! "$CONTAINER_ID" ]; then
	docker run ${DOCKER_OPT} \
		--volume=/dev:/dev:rw \
		--shm-size=1gb \
		--env=TERM=xterm-256color \
		--name=${DOCKER_NAME} \
		$NAME_IMAGE:latest \
		bash
else
	docker start $CONTAINER_ID
	docker attach $CONTAINER_ID
fi

xhost -local:`hostname`-Docker

