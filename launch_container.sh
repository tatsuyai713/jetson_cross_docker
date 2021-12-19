#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)


NAME_IMAGE='jetson_cross_ws'

if [ ! "$(docker image ls -q ${NAME_IMAGE})" ]; then
	if [ ! $# -ne 1 ]; then
		if [ "setup" = $1 ]; then
			echo "Image ${NAME_IMAGE} does not exist."
			echo 'Now building image without proxy...'
			docker build --file=./noproxy.dockerfile -t $NAME_IMAGE . --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME=$USER
			
		else
			echo "Docker image not found. Please setup first!"
			exit
		fi
	else
		echo "Docker image not found. Please setup first!"
		exit
  	fi
fi

# Commit
if [ ! $# -ne 1 ]; then
	if [ "commit" = $1 ]; then
		echo 'Now commiting docker container...'
		docker commit jetson_cross_docker jetson_cross_ws:latest
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
DOCKER_OPT="${DOCKER_OPT} --runtime=nvidia "
DOCKER_OPT="${DOCKER_OPT} --privileged -it "

## Allow X11 Connection
xhost +local:`hostname`-Docker
CONTAINER_ID=$(docker ps -a -f name=jetson_cross_docker --format "{{.ID}}")
if [ ! "$CONTAINER_ID" ]; then
	docker run ${DOCKER_OPT} \
		--volume=/dev:/dev:rw \
		--shm-size=1gb \
		--env=TERM=xterm-256color \
		--net=host \
		--name=${DOCKER_NAME} \
		jetson_cross_ws:latest \
		bash
else
	docker start $CONTAINER_ID
	docker attach $CONTAINER_ID
fi

xhost -local:`hostname`-Docker

