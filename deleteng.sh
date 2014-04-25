#!/bin/bash

ACCOUNT=$1
UUID=$2
BYPASS=$3

supernova $ACCOUNT $BYPASS delete $UUID
