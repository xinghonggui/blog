#!/bin/sh
#<?php die();?>
###############################################################################
#1.数据库信息定义  
mysql_host="127.0.0.1"  
mysql_port="3306"
mysql_user="root"
mysql_passwd="123456"
  
#sql备份目录  
root_dir="/home/backup"
back_dir="/home/backup/tmp"
data_dir="tmp"
mkdir_tmp="/home/backup/data_dir"
store_dir="data_dir"
mysql_bin_mysql="/usr/local/mysql/bin/mysql"
mysql_bin_mysqldump="/usr/local/mysql/bin/mysqldump"

################################################################################
if [ ! -d $back_dir ]; then  
    mkdir -p $back_dir  
fi

if [ ! -d $mkdir_tmp ]; then  
    mkdir -p $mkdir_tmp
fi

#备份的数据库数组  
db_arr=$(echo "show databases;" | $mysql_bin_mysql -u$mysql_user -p$mysql_passwd -h$mysql_host -P$mysql_port | grep -v Database | grep -v test | grep -v schema | grep -v demo | grep -v mysql)  
#不需要备份的单例数据库  
nodeldb=" "  
  
#当前日期  
date=$(date -d '+0 days' +%Y%m%d)

#zip打包密码
zipname="DB_"$mysql_host"_"$date".tar.gz"

#2.进入到备份目录  
cd $back_dir
#3.循环备份  
for dbname in ${db_arr}
do
    if [[ $dbname != $nodeldb ]]; then
        sqlfile=$dbname-$date".sql"
        $mysql_bin_mysqldump -u$mysql_user -p$mysql_passwd -h$mysql_host -P$mysql_port $dbname >$sqlfile  
    fi
done

#4.tar打包所有的sql文件 
tar -zcf $root_dir/$store_dir/$zipname  $root_dir/$data_dir

#打包成功后删除sql文件
if [ $? == 0 ]; then
	if [[ $back_dir != "/" ]]; then
    	rm -r $back_dir
	fi
fi

exit