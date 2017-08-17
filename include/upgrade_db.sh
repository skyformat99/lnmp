#!/bin/bash
echo
echo -e "${YELLOW}Which MYSQL version you want upgrade to?"
echo -e "${YELLOW}1)${WHITE} mysql5.6;"
echo -e "${YELLOW}2)${WHITE} mysql5.7;"
read -p "You select mysql version is: " mysql_version_input
echo
read -p "mysql server root password (default:root): " mysql_root_pass
mysql_root_pass=${mysql_root_pass:=root}
case $mysql_version_input in
1)
	service mysqld stop &&	. include/mysql-5.6.sh
;;
2)
	service mysqld stop &&	. include/mysql-5.7.sh
;;
*)
	echo -e "${RED}You input a wrong number for mysql version upgrade"
;;
esac

#Add mysql bin to path
cat >> /etc/profile  << EOF 
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/mysql/bin
EOF
. /etc/profile
