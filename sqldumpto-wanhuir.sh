#!/bin/bash
#Shell Command For Backup MySQL Database Everyday Automatically By Crontab
#Author : Carlos Wong
#Date : 2010-08-24
#配置参数
BACKUP_DIR=./
DATE=`date '+%Y%m%d-%H%M'` #日期格式（作为文件名）
DUMPFILE=$DATE-qcloud.sql #备份文件名
echo '开始从qcloud服务器中导出数据库game'
cd $BACKUP_DIR
mysqldump -uroot -plong game > $DUMPFILE
echo '数据库game导出完成'

echo '导出文件拷贝到玩会儿服务器'
echo '--等待输入玩会儿服务器密码--'
cp $DUMPFILE /home/ubuntu/long/sql/
scp $DUMPFILE wanhuir@wanhuir.com:/home/wanhuir/xiaolong/sql/

echo '拷贝完成！'
echo '数据库game导入玩会儿服务器'
mysqldump -h222.73.85.232 -pwan123 game < ./$DUMPFILE

rm $DUMPFILE
