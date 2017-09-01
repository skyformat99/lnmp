#!/bin/bash

clear
. ./include/common.sh

echo -e "$GREEN
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author	Hehl <1181554113@qq.com>                            # 
# Blog	        Http://www.yunweijilu.com                           #
#####################################################################"
. ./include/sysinfo.sh >/dev/null 2>&1

#Uninstall Nginx
uninstall_ngx(){
echo -e "$YELLOW"
read -p "Please Choose Uninstall Nginx or Not! ( y/n )[n]" uninstall_ngx
echo

read -p "Please Choose Uninstall Mysql or Not! ( y/n )[n]" uninstall_mysql
echo

read -p "Please Choose Uninstall Php or Not! ( y/n )[n]" uninstall_php
echo

read -p "Please Choose Uninstall Redis or Not! ( y/n )[n]" uninstall_redis
echo

read -p "Please Choose Uninstall Pureftpd or Not! ( y/n )[n]" uninstall_ftp

echo -e "$RED"
case $uninstall_ngx in
y|Y)
	if [ -d "/usr/local/nginx" ];then
		service nginx stop >/dev/null
		if [ "$os" == "centos" ];then
			chkconfig nginx off && chkconfig save
		elif [ $os == "ubuntu" ];then
			update-rc.d nginx remove	
		fi
		rm -rf /etc/init.d/nginx
		rm -rf /usr/local/nginx /usr/bin/nginx && echo  "Uninstall nginx successful!"
	else
		echo
		echo "No Nginx installed in your system!!"
	fi
;;
n|N)
	echo
	echo  "You select not uninstall Nginx!"
;;
*)
	echo
	echo  "Input error to uninstall nginx! "
;;
esac
}
uninstall_ngx
	
#Uninstall mysql
uninstall_mysql(){
case $uninstall_mysql in
y|Y)
	if [ -d $mysql_local ];then
		if [ `ps aux | grep mysql | grep -v grep|wc -l` -ne "0" ];then
			service mysqld start
		fi
		echo
		echo -e "Enter old mysql password for Backup:"
		$MYSQLDUMP -u$MYSQLUSR -p --all-databases > $mysql_data_backup 
		service mysqld stop >/dev/null 2>&1
		sleep 3
		[ -d /var/lib/mysql ] && rm -rf /var/lib/mysql
		[ -f "/etc/init.d/mysqld" ] && rm -rf /etc/init.d/mysqld
#Backup Data
		[ ! -d /data/backup ] && mkdir -p /data/backup
		[ -f "/etc/my.cnf" ] && cp -f /etc/my.cnf $data_backup_dir/my.cnf_`date +%Y%m%d%H%M`
		[ -d "/data/mysql" ] && mv -f /data/mysql $data_backup_dir/mysql_`date +%Y%m%d%H%M`

		ps aux | grep mysql | grep -v grep | awk '{ print $2 }' | xargs kill -9 >/dev/null 2>&1
        	rm -rf /usr/local/mysql /usr/bin/mysql
		echo
		[ `ps aux | grep mysql | grep -v grep|wc -l` -eq "0" ] && [ ! -d $mysql_local ] && echo  "Uninstall mysql successful!"
		cp -f /etc/profile /etc/profile_bk &&  sed -i '/mysql\/bin/'d /etc/profile && sed -i '/export PATH=\/bin/'d /etc/profile
		echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:" >> /etc/profile
	else
		echo
		echo -e "No Mysql Server installed in your system!!"
	fi
	
;;
n|N)
        echo
        echo  "You select not uninstall Mysql!"
;;
*)
        echo
        echo  "Input error to uninstall Mysql!!! "
;;
esac
}
uninstall_mysql

#Uninstall Php
uninstall_php(){
case $uninstall_php in
y|Y)
	if [ -d "/usr/local/php" ];then
		service php-fpm stop >/dev/null 2>&1
		ps -ef | grep php-fpm | grep -v grep | awk  '{print $2}' | xargs kill -9 >/dev/null 2>&1
		if [ "$os" == "centos" ];then
			chkconfig php-fpm off && chkconfig save
		elif [ $os == "ubuntu" ];then
			update-rc.d php-fpm remove
		fi
        	rm -rf /usr/local/php /usr/bin/php /etc/my.cnf /etc/init.d/php-fpm
		echo
		echo  "Uninstall Php successful!"
	else
		echo
		echo "No PHP installed in your system!!"
	fi
;;
n|N)
        echo
        echo "You select not uninstall Php!"
;;
*)
        echo
        echo  "Input error to uninstall Php! "
;;
esac
}
uninstall_php

#Uninstall Redis
uninstall_redis(){
echo
case $uninstall_redis in
y|Y)
	if [ ! -d $redis_install_dir ];then
		echo "No Redis installed in your system!"
	else
		service redis stop >/dev/null 2>&1
		if [ $os == "ubuntu" ];then
			apt-get remove redis -f >/dev/null 2>&1
			update-rc.d -f redis remove >/dev/null 2>&1
		fi
		ps aux | grep redis | grep -v grep | awk '{ print $2 }' | xargs kill -9 >/dev/null 2>&1
		rm -rf $redis_install_dir /etc/init.d/redis $redis_conf_dir
		echo
		echo "Uninstall Redis successful!"
	
	fi
;;
n|N)
	echo "You select not uninstall Redis!"
;;
*)
	echo  "Input error to uninstall Redis! "
;;
esac
}
uninstall_redis

uninstall_pureftp(){
echo
case $uninstall_ftp in
y|Y)
	if [ ! -d $ftp_dir ];then
		echo "No Pureftp installed in your system!"
	else
		service pureftpd stop
		if [ $os == "ubuntu" ];then
			apt-get remove pureftpd -f >/dev/null 2>&1
			update-rc.d -f pureftpd remove >/dev/null 2>&1
		fi
		ps aux | grep pureftp | grep -v grep | awk '{ print $2 }' | xargs kill -9 >/dev/null 2>&1
		rm -rf $ftp_dir /etc/init.d/pureftpd
		echo
		echo "Uninstall Pureftpd successful!"
	fi
;;
n|N)
	echo "You select not uninstall Pureftpd!"
;;
*)
	echo  "Input error to uninstall Pureftpd! "
;;
esac
}
uninstall_pureftp

echo -e "$WHITE"

#del define PS1
sed 's/"PS1="\[\"//g' /etc/bashrc >/dev/null 2>&1
sed -i '/PS1=.*40m.*/d' /etc/bashrc >/dev/null 2>&1

#set color of PS1
cat >> /etc/bashrc  << EOF 
PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[35;40m\]\W\[\e[0m\]]\\$ "
EOF
. /etc/bashrc

