#!/bin/sh
#<?php die();?>
########################################################################################
#mongodump命令路径  
DUMP="/data/mongodb/bin/mongodump"
#临时备份目录
OUT_DIR="/home/backup/mongodb_bak_now"
#备份存放路径
TAR_DIR="/home/backup/data_dir"
IPPORT="127.0.0.1:27017"
########################################################################################
if [ ! -d $OUT_DIR ]; then
    mkdir -p $OUT_DIR
fi

if [ ! -d $TAR_DIR ]; then
    mkdir -p $TAR_DIR
fi

#获取当前系统时间  
DATE=$(date -d '+0 days' +%Y%m%d)
#最终保存的数据库备份文件
TAR_BAK="MONGODB_"$IPPORT"_"$DATE".tar.gz"

cd $OUT_DIR
mkdir -p $OUT_DIR"/"$DATE
#备份全部数据库
$DUMP -h $IPPORT --oplog -o $OUT_DIR/$DATE
#压缩为.tar.gz格式
tar -zcvf $TAR_DIR"/"$TAR_BAK $OUT_DIR"/"$DATE
if [ $? == 0 ]; then
	if [[ $OUT_DIR != "/" ]]; then
    	rm -r $OUT_DIR
	fi
fi
exit