#!/bin/bash
. include/common.sh
. include/public.sh
. include/sysinfo.sh >/dev/null 2>&1

clear
echo -e "${GREEN}
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################"

#Menu of upgrade
Menu_Upgrade(){
echo -e "${YELLOW}Please input the number which  you want upgrade?"
echo
echo -e "${YELLOW}1)${WHITE} Upgrade Nginx;"
echo -e "${YELLOW}2)${WHITE} Upgrade Mysql;"
echo -e "${YELLOW}3)${WHITE} Upgrade Php;"
echo
read -p "You select number is: " select_upgrade
case $select_upgrade in
1)
	. include/upgrade_web.sh
;;
2)
	if [ ! -d $mysql_local ];then
		echo "No Mysql Server in $mysql_local !"
		exit
	else
		. include/upgrade_db.sh
	fi
;;
3)
	. include/upgrade_php.sh
;;
*)
	echo "Error, input wrong number!"
;;
esac
}

Menu_Upgrade 2>&1 | tee ./upgrade.log
