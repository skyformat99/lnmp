#!/bin/bash
. include/common.sh
echo -e "$GREEN"
clear
echo -e "${GREEN}
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#	Auto backup or inport Mysql Sql file to Mysql server        #
#####################################################################
"
#Mysql SQL Data backup
mysql_sql_back(){
if [[ ! -d ${data_backup_dir} ]] ; then
	mkdir -p $data_backup_dir
        echo -e " \033[32mCreat $data_backup_dir Successful! \033[0m"
else
	echo -e " \033[32m$data_backup_dir is already exists, backup stoped!\033[0m"
	exit
fi

if [ `ps aux | grep mysql|grep -v grep|wc -l` -eq "0" ];then
	/etc/init.d/mysqld start
fi
$MYSQLDUMP -u$MYSQLUSR -p"$mysql_root_pass" --all-databases > $mysql_data_backup
	
if [[ $? -eq 0  ]];then
        echo -e " \033[32m Backup Mysql Data success! \033[0m"
else
        echo -e " \033[32m Back failed,pls check...\033[0m " 
fi
}

#Mysql SQL Data import
mysql_sql_import(){
$mysql_cmd -u"$MYSQLUSR" -p"$mysql_root_pass" < $mysql_data_backup
}

#Mysql backup or import Menu
if [ -z $1 ];then
	echo -e "${WHITE}Usage {$0 backup|import}${WHITE}"
	echo
else
	echo -e "${YELLOW}"
	read -p "Please input Mysql server root password : " mysql_root_pass

	if [ $1 == "backup" ];then
		echo -e "You select backup Mysql Data from $mysql_data"
		mysql_sql_back
	elif [ $1 == "import" ];then
		echo -e "You select import Mysql Data to $data_backup_dir"
		mysql_sql_import
	else
		echo -e "Usage {$0 backup|import}"
	fi
fi
