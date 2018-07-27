#!/bin/sh
#<?php die();?>
###############################################################################
root_dir="/home/backup"
mkdir_tmp="/home/backup/data_dir"
store_dir="data_dir"
web_dir="/data/wwwroot/"
################################################################################
if [ ! -d $mkdir_tmp ]; then  
    mkdir -p $mkdir_tmp
fi

date=$(date -d '+0 days' +%Y%m%d)


zipname="WEB_"$date".tar.gz"

#tar打包所有文件
tar -zcf $root_dir/$store_dir/$zipname  $web_dir

exit