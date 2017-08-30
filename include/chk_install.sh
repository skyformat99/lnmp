#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################

#check run status
echo
echo -e "${GREEN}---------------------------------------------------------------------"
for i in  nginx mysql php redis pureftp
do
chk_status=`ps aux | grep $i | grep -v grep | wc -l`
[ "$chk_status" -ne 0 ] && echo "$i is Running!" || echo "$i is NOT Running!"
[ "$chk_status" -ne 0 ] && echo "You can use:  service $i start|stop|restart|status|reload"
echo "---------------------------------------------------------------------"
done
echo -e "\033[0m"
if [[ $sync_time_yn =~ ^[y,Y]$ ]] || [[ $repo_yn =~ ^[y,Y]$ ]] || [[ $install_ngx_yn =~ ^[y,Y]$ ]] || [[ $install_mysql_yn =~ ^[y,Y]$ ]] || [[ $install_php_yn =~ ^[y,Y]$ ]] || [[ $install_redis_yn =~ ^[y,Y]$ ]];then
	time_end=`date +%s`
	((time_use=${time_end}-${time_begin}))
	((time_use_m=${time_use}/60))
	((time_use_s=${time_use}%60))
	echo "Install lnmp use ${time_use_m}Min ${time_use_s}Sec "
fi
if [[ $install_mysql_yn =~ ^[y,Y] ]];then
	kill $$ > /dev/null 2>&1
fi
