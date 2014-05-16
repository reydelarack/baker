#!/bin/bash

NAME="baker-build-test-`date +%s`"

ACCOUNT=$1
IMAGE=$2
FLAVOR=$3
SCRIPT=$4
BYPASS=$5

function timestamp() {
	date +"%Y-%m-%d %H:%M:%SZ @%s" | tr '\n' ' '
}

BAKERDIR="bash `dirname $(readlink -f $0)`"

timestamp
echo Started

UUID=`$BAKERDIR/bootng.sh "$ACCOUNT" "$IMAGE" "$FLAVOR" "$NAME" "$BYPASS"`

timestamp
echo  UUID: $UUID

IP=`$BAKERDIR/ipng.sh $ACCOUNT $UUID "$BYPASS"`

timestamp
echo Got IP: $IP

$BAKERDIR/alive.sh $IP

timestamp
echo IP is alive

$BAKERDIR/deleteng.sh $ACCOUNT $UUID "$BYPASS"

timestamp
echo Deleted $UUID
