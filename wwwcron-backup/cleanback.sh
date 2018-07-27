#!/bin/sh
#<?php die();?>
#1.参数配置
################################################################################
backup_dir1="/home/backup/data_dir/"    #文件备份目录
backdir_arr=($backup_dir1)  
keep_time=1                             #过期文件的时间  
###############################################################################

#每天都清理n周前的文件
week=$(date +%W)
flag=`expr $week % 1`

#2.清理过期文件
if [ $flag -eq 0 ]; then
    for dir in ${backdir_arr[*]}
    do
        if [ -d $dir ]; then
            #查找n周前的文件数据
            clean_arr=`find $dir -type f -mtime +$keep_time -exec ls {} \;`
            for cleanfile in ${clean_arr}
            do
                rm $cleanfile
            done
        fi
    done
fi