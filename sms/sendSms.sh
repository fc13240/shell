#!/bin/bash

CURRENT_DIR=`dirname $0`
LOG_DIR=$CURRENT_DIR/log;
mkdir -p $LOG_DIR
LOG_PATH=$LOG_DIR/$(date +%Y-%m-%d).log

/e/wnmp/php/php5.3.10/php $CURRENT_DIR/send.php $1 $2>>$LOG_PATH
echo >> $LOG_PATH