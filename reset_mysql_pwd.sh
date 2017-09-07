#!/bin/bash
. include/common.sh
clear
echo -e "$GREEN
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>       20170907             #
# Blog          Http://www.yunweijilu.com                           #
# Auto reset password  of mysql server				    #
#####################################################################"

echo -e "$WHITE"
add_skip(){
if [ -f /etc/my.cnf ];then
	sed -i 's/\[mysqld\]/\[mysqld\]\nskip-grant-tables/g' /etc/my.cnf
else
	echo -e "${RED}NO my.cnf in /etc/"
fi
}

del_skip(){
	sed -i 's/skip-grant-tables//g' /etc/my.cnf
}

reset_mysql_pwd(){
	read -p "Please input New Mysql root password:" mysql_pwd
	add_skip
	service mysqld restart
	$mysql_cmd -uroot -e "use mysql;UPDATE user SET password=PASSWORD('$mysql_pwd') WHERE user='root' AND host='127.0.0.1' OR host='%' OR host='localhost'"
	del_skip
	service mysqld restart
	echo -e "New Mysql server root password is\033[41m $mysql_pwd\033[0m"	
}
reset_mysql_pwd
