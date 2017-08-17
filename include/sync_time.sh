#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################

#sync_time
sync_time(){
check_ntpdate=`which ntpdate|grep ntpdate |wc -l`
if [[ $os == "centos" ]];then
	[ "$check_ntpdate" != "1" ] && yum install -y ntp
else
	apt-get install ntpdate -y
fi
ntpdate asia.pool.ntp.org
hwclock -w  >/dev/null 2>&1 
}
sync_time


#check_timezone
sync_zone(){
zone=`date -R | grep '+800'|wc -l`
test $zone -eq "1" && echo "Time Zone: Shanghai " || rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 
}
sync_zone
