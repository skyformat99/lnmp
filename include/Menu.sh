#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################

echo -e "$GREEN"
echo "                Version:"
echo "+----------------------------------------------------------------------+ "
echo "|      NGINX          |      nginx-1.12.0                             |"
echo " --------------------- ------------------------------------------------- "
echo "|      PHP            |      ${php_version[1]}   |  ${php_version[2]}   |"
echo " --------------------- ------------------------------------------------- "
echo "|      MYSQL          |      ${mysql_version[1]} |  ${mysql_version[4]}  |"
echo "+----------------------------------------------------------------------+ "

#Display menu and choose  install or not, then run it
Menu(){
echo  -e "$YELLOW"
while :;do echo
	read -p "Do you want sync Beijing time?(y/n)" sync_time_yn
	if [[ ! $sync_time_yn =~ ^[y,Y,n,N]$ ]];then
		echo -e "\033[0mPlease input y or n\033[33m"
	else
		break	
	fi
done
		
while :;do echo
	read -p "Do you want set Aliyun Repo?(y/n)" repo_yn
	if [[ ! $repo_yn =~ ^[y,Y,n,N]$ ]];then
		echo -e "\033[0mPlease input y or n\033[33m"
	else
		break
	fi
done

while :;do echo
	read -p "Do you want Install Nginx?(y/n)" install_ngx_yn
	if [[ ! $install_ngx_yn =~ ^[y,Y,n,N]$ ]];then
		echo -e "\033[0mPlease input y or n\033[33m"
	else
		break
	fi
done

while :;do echo
	read -p "Do you want Install Mysql?(y/n)" install_mysql_yn
	if [[ ! $install_mysql_yn =~ ^[y,Y,n,N]$ ]];then
		echo -e "\033[0mPlease input y or n\033[33m"
	else
		break
	fi
done

if [ "$install_mysql_yn" == "y" -o "$install_mysql_yn" == "Y" ];then
	if [ -d "/usr/local/mysql"  ];then
		echo
		echo -e "${RED}You had installed Mysql Server!$YELLOW"	
	else
		echo -e "Please choose MYSQL version:
		$RED 1)$WHITE ${mysql_version[1]} $GREEN( Default );
		$RED 2)$WHITE mysql-5.7.16 $GREEN( RAM size must large than 2 GB! );"
		echo -e "$WHITE"
		read -p "Please input the number of your choose:" mysql_version_select
		if [ -z "$mysql_version_select" -o "$mysql_version_select" == 1 -o "$mysql_version_select" == 2 ];then
			mysql_install_way
			[ -z "$mysql_version_select" ] && mysql_version_select=1
			echo
			read -p "mysql server root password (default:root): " mysql_root_pass
			mysql_root_pass=${mysql_root_pass:=root}
			echo  -e "Mysql root password: ${mysql_root_pass}"
			echo -e "$WHITE"
		else
			echo -e "Input error number for choose mysql version!"
		fi
	fi
fi

while :;do echo -e "$YELLOW"
	read -p "Do you want Install PHP?(y/n)" install_php_yn
	if [[ ! $install_php_yn =~ ^[y,Y,n,N]$ ]];then
		echo -e "\033[0mPlease input y or n\033[33m"
	else
		break
	fi
done

if [ "$install_php_yn" == "y" -o "$install_php_yn" == "Y" ];then
	if [ -d "/usr/local/php" ];then
		echo -e "$RED You had installed PHP!"
		echo -e "$YELLOW"
	else
		echo -e "Please choose PHP version:
		$RED 1)$WHITE php-5.6.30 $GREEN( Default );
		$RED 2)$WHITE php-7.1.6;"
		read -p "Your select:" php_version_select
		[ -z "$php_version_select" ] && php_version_select="1"
		echo  -e "$YELLOW"	
	fi
fi

while :;do echo
	read -p "Do you want Install Redis?(y/n)" install_redis_yn
	if [[ ! $install_redis_yn =~ ^[y,Y,n,N]$ ]];then
		echo -e "\033[0mPlease input y or n\033[33m"
	else
		break
	fi
done
echo -e "$WHITE"

#Sync time
sync_time

#Select use Aliyun Repo
case $repo_yn in
y|Y)
        . ./include/set_repo.sh
        ;;
*)
        echo "Not install or input wrong value for Aliyun Repo!"
        ;;
esac

#install nginx
nginx -v 2>/dev/null
if [  "$install_ngx_yn" == "y" -a $? -eq "0" ];then
	echo "You select install Nginx"
	echo -e "Nginx is already installed,Please check!"
elif	[  "$install_ngx_yn" == "y" ];then
	. ./include/nginx.sh
else
	echo "Not install or input wrong value for Nginx!"
fi

#install mysql
if [ "$mysql_version_select" == "1" ];then
        echo "You select install ${mysql_version[1]}"
        . ./include/mysql-5.6.sh
elif	[ "$mysql_version_select" == "2" ];then
        echo "You select install Mysql-5.7.16"
	. ./include/mysql-5.7.sh
else
	echo "Not install or input wrong value for Mysql!"
fi

#install php
if [[  $php_version_select -eq 1 ]];then
        echo "You select install ${php_bz[1]}"
        . ./include/php.sh
elif	[[ $php_version_select -eq 2 ]];then
	echo "You select install ${php_bz[2]}"
        . ./include/php.sh
else
	 echo "Not install or input wrong value for Php!"
fi
#install redis
if [ "$install_redis_yn" == "y" -o "$install_redis_yn" == "Y" ];then
	echo "You select instll Redis."
	. ./include/redis.sh
else
	echo "Not install or input wrong value for Redis!" 
fi

}
Menu

#set color of PS1
if [[ $os == "ubuntu" ]];then
cat >> ~/.bashrc  << EOF 
PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[35;40m\]\W\[\e[0m\]]\\$ "
EOF
else
cat >> /etc/profile  << EOF 
PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[35;40m\]\W\[\e[0m\]]\\$ "
EOF
fi
