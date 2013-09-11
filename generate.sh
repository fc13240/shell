#!/bin/bash

GENERATE_LOG=/tonny/log/generate_$(date +%Y-%m-%d).log
echo $(date '+%Y-%m-%d %H:%M:%S')_start >> $GENERATE_LOG
/opt/turbocms/bin/generate.sh
echo $(date '+%Y-%m-%d %H:%M:%S')_end >> $GENERATE_LOG