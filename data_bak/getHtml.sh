#!/bin/bash

CONF_PATH=D:\\test\\data\\config\\
BAK_PATH=D:\\test\\data\\bak\\

startTime=$(date +%s)
for file in ` ls $CONF_PATH `
do
	source $CONF_PATH$file;
	mkdir -p $BAK_PATH$target
	for((index=0;index<${#params[@]} ; index++))
	do
		echo $index $target${params[$index]}
		curl -o $BAK_PATH$target${params[$index]} $url${params[$index]} > /dev/null 2>&1
	done
done
echo takes $(($(date +%s) - $startTime)) s
find $BAK_PATH -maxdepth 3 -ctime +0 -exec rm -rf {} \;