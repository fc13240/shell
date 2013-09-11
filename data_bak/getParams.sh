#!/bin/bash

INIT_PATH=${1}/
FILTER=${2}

result=`ls $INIT_PATH$FILTER`

echo 'params=('${result//$INIT_PATH/''}')'