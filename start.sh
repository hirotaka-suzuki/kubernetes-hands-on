#!/usr/bin/env bash

VERSION=0.0.1
LOCKFILE=init.lock
USERFILE=user.txt

IMAGETAG="kubernetes-hans-on:$VERSION-$(grep FROM docker/Dockerfile | head -n 1 | cut -d':' -f 2)"

function end() {
  if [ -f $USERFILE ]; then
    rm -f $USERFILE
  fi

  rm -f $LOCKFILE
}

set -e

if [ -f $LOCKFILE ]; then
  echo $0 is locked
  exit 1
fi

touch $LOCKFILE

trap end EXIT HUP INT QUIT TERM ERR

read -p "GCP Porject: " GCP_PROJECT
read -p "User Name (firstname.lastname): " USERNAME
read -p "Domain: " DOMAIN
read -sp "Password: " PASSWD

echo "${USERNAME}:${PASSWD}" > $USERFILE

DOCKER_BUILDKIT=1  docker build . --build-arg username=$USERNAME --secret id=userpasswd,src=./$USERFILE -t $IMAGETAG -f docker/Dockerfile
rm -f $USERFILE

SCRIPT_DIR=$(cd $(dirname $0); pwd)
docker run -v $SCRIPT_DIR/terraform:/home/$USER/terraform -u $USERNAME -e GCP_PROJECT="${GCP_PROJECT}" -e DOMAIN="${DOMAIN}" -it $IMAGETAG
