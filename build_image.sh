#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)

sudo apt update
sudo apt install -y qemu-user-static

IMAGE_NAME="ghcr.io/tatsuyai713/jetson_cross_image"
IMAGE_VERSION="5.1.2"

cd $(dirname $0)
SCRIPT_DIR=$(pwd)

USER_IMAGE_NAME="jetson_cross_image_$USER"

echo "Build Container"
docker build --file=./noproxy.dockerfile -t $USER_IMAGE_NAME . --platform=linux/arm64 --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME=$USER
