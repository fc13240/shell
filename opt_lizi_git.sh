#!/bin/bash

GIT_BRANCH=$1

if [ $# == 0 ]
then
  echo "Usage:$0 <branch>"
  echo "<branch> missing. using default branch: release"
  GIT_BRANCH=release
fi

# symbolic link
RUN_PATH=/data/www/fandongxi
WORK_PATH=/data/www/fdx_work
CURRENT_TIME=`date +%Y%m%d_%H%M%S`
# TMP_PATH="/data/www_release/${GIT_BRANCH}_${CURRENT_TIME}"

# change directory first
cd $WORK_PATH

git add .
git stash
git stash drop

# switched to the 'release' branch
git checkout ${GIT_BRANCH}

# pull the latest updates from git repository
# 122.11.50.40 pwd= fdx!@#
git pull origin ${GIT_BRANCH}

# make tmp dir
# mkdir $TMP_PATH

# copy project files
# cp -rf * $TMP_PATH/

# replacements
# sed -i "s:'root'/\*mysql\*/:'web'/\*mysql\*/:" ${WORK_PATH}/App/Config/Global.php
#sed -i 's:123::' ${WORK_PATH}/App/Config/Global.php
sed -i "s:'10.10.[0-9]*.[0-9]*'/\*memcache\*/:'127.0.0.1'/\*memcache\*/:" ${WORK_PATH}/App/Config/Global.php
#sed -i "s:'10.10.[0-9]*.[0-9]*'/\*gearman\*/:'192.168.1.60'/\*gearman\*/:" ${WORK_PATH}/App/Config/Global.php
sed -i "s:'10.10.[0-9]*.[0-9]*'/\*database\*/:'127.0.0.1'/\*database\*/:" ${WORK_PATH}/App/Config/Global.php
#sed -i "s:'10.10.[0-9]*.[0-9]*'/\*sphinx\*/:'192.168.1.40'/\*sphinx\*/:" ${WORK_PATH}/App/Config/Global.php
#sed -i "s:\"10.10.[0-9]*.[0-9]*\"/\*redis\*/:'127.0.0.1'/\*redis\*/:" ${WORK_PATH}/App/Config/Global.php
#sed -i "s:'122.11.50.40*'/\*mail\*/:'192.168.1.40'/\*mail\*/:" ${WORK_PATH}/App/Config/Global.php
#sed -i 's:9312/\*sphinx\*/:9313/\*sphinx\*/:' ${TMP_PATH}/App/Config/Global.php
#sed -i "s:false/\*sphinx\*/:false/\*sphinx\*/:" ${TMP_PATH}/App/Config/Global.php
sed -i 's:fan.com:fan2.com:' ${WORK_PATH}/App/Config/Global.php
sed -i 's:test.com:fan2.com:' ${WORK_PATH}/App/Config/Admin.php
sed -i 's:test.com:fan2.com:' ${WORK_PATH}/App/Config/Site.php
sed -i 's:test.com:fan2.com:' ${WORK_PATH}/App/Config/Wap.php
sed -i 's:misc.fan.com:misc.fan2.com:' ${WORK_PATH}/App/Config/Site.php
sed -i 's:www.fan.com:www.fan2.com:' ${WORK_PATH}/App/Config/Site.php
sed -i "s/\x27Front_Cache_Version\x27 => \x27.*\x27/\x27Front_Cache_Version\x27 => \x27${CURRENT_TIME}\x27/" ${WORK_PATH}/App/Config/Site.php
sed -i "s/\x27Front_Cache_Version_Min\x27 => \x27.*\x27/\x27Front_Cache_Version_Min\x27 => \x27${CURRENT_TIME}\x27/" ${WORK_PATH}/App/Config/Site.php
sed -i 's:http\:\/\/misc.fan.com:http\:\/\/misc.fan2.com:' ${WORK_PATH}/site/view/_elements/header_element.php
sed -i 's:d\:/:/data/images/tmp/:' ${WORK_PATH}/App/Config/Site.php
sed -i 's:/var/images:/data/images:' ${WORK_PATH}/App/Config/Upload.php
#sed -i 's:"10.10.[0-9]*.[0-9]*"/\*mongodb\*/:"192.168.1.40"/\*mongodb\*/:' ${WORK_PATH}/App/Config/Global.php
sed -i "s:'10.10.[0-9]*.[0-9]*'/\*memsession\*/:'127.0.0.1'/\*memsession\*/:" ${WORK_PATH}/App/Config/Global.php
#sed -i "s:'10.10.[0-9]*.[0-9]*'/\*memcache\*/:'127.0.0.1'/\*memcache\*/:" ${WORK_PATH}/App/Config/Cache.php
sed -i "s:array( 'img.fandongxi.com', 'img.test.com', 'img.fan.com' ):array( 'img.fandongxi.com', 'img.test.com', 'img.fan.com', 'img.fan2.com' ):" ${WORK_PATH}/App/Format/Image.class.php

# tag this with time
#git tag "${GIT_BRANCH}_${CURRENT_TIME}"

# clear cache, etc...
rm -rf ${WORK_PATH}/admin/cache
mkdir ${WORK_PATH}/admin/cache
mkdir ${WORK_PATH}/admin/cache/view
chmod 777 ${WORK_PATH}/admin/cache -R

rm -rf ${WORK_PATH}/site/cache
mkdir ${WORK_PATH}/site/cache
mkdir ${WORK_PATH}/site/cache/tpl
chmod 777 ${WORK_PATH}/site/cache -R

# rm -rf ${RUN_PATH}/.gitignore
# rm -rf ${RUN_PATH}/site/.htaccess
# rm -rf ${RUN_PATH}/wap/.htaccess

# /opt/fandongxi-shell/cache_version_sphinx.sh
# /opt/fandongxi-shell/cache_version_product.sh

# rebuild link
ln -sfn $WORK_PATH $RUN_PATH

# chmod -R g+w ${WORK_PATH}

echo "release finished, TAGged AS: ${GIT_BRANCH}_${CURRENT_TIME}"

