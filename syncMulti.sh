#!/bin/bash

WATCHER_PATH=/tonny/tempDir/
TEMP_DATA_PATH=/tonny/.tempData.json
URL=http://localhost:3333
function run(){
    startTime=$(date +%s)
    echo '### start ###'
    curl -o $TEMP_DATA_PATH $URL 2>/dev/null
    /usr/local/bin/node /tonny/nodejs/watcher/dealTreeMemory.js -f $TEMP_DATA_PATH
    rm -rf $TEMP_DATA_PATH
    num=`ls ${WATCHER_PATH}|wc -l`
    if [ $num -gt 0 ]; then
            #rsync multi server target
            /usr/bin/rsync -WPaz --password-file=/tonny/192.168.171.128_root.password ${WATCHER_PATH} rsync@192.168.171.128::serverOne
            /usr/bin/rsync -WPaz --password-file=/tonny/192.168.171.128_root.password ${WATCHER_PATH} rsync@192.168.171.128::serverTwo
            /usr/bin/rsync -WPaz --password-file=/tonny/192.168.171.128_root.password ${WATCHER_PATH} rsync@192.168.171.128::serverThree

            #clear warcher path
            rm -rf ${WATCHER_PATH}*
    else
            echo 'no change'
    fi
    usedTime=$(($(date +%s) - $startTime))
    echo '### 用时'$usedTime'秒 ###'
    sleep 20
    #repeat run
    run
}
run
