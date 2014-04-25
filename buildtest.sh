#!/bin/bash

NAME="baker-`date +%s`"

ACCOUNT=$1
IMAGE=$2
FLAVOR=$3
SCRIPT=$4
BYPASS=$5

BAKERDIR="bash `dirname $(readlink -f $0)`"

UUID=`$BAKERDIR/bootng.sh "$ACCOUNT" "$IMAGE" "$FLAVOR" "$NAME" "$BYPASS"`

IP=`$BAKERDIR/ipng.sh $ACCOUNT $UUID "$BYPASS"`

$BAKERDIR/alive.sh $IP

echo $UUID

$BAKERDIR/deleteng.sh $ACCOUNT $UUID "$BYPASS"
