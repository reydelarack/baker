#!/bin/bash

ACCOUNT=$1
IMAGE=${2:-e28f50b0-7a94-4161-a758-36010c69c8ce}
FLAVOR=${3:-performance1-1}
NAME=${4:-"baker-`date +%s`"}
BYPASS=$5

SSHKEY=~/.ssh/id_rsa.pub

supernova $ACCOUNT $BYPASS boot --disk-config MANUAL --image $IMAGE --flavor $FLAVOR \
--file /root/.ssh/authorized_keys=$SSHKEY $NAME  | grep id | head -n 1 | awk '{print $4}'
