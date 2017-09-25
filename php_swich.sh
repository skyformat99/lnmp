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
#	Swich PHP version					    #
#####################################################################"

#Menu of swich PHP
Menu_swich_php(){
echo -e "${YELLOW}Please select PHP version you want swich to?"
echo
echo -e "${YELLOW}1)${WHITE} Php-5.6.30;"
echo -e "${YELLOW}2)${WHITE} Php-7.1.6;"
echo -e "${YELLOW}3)${WHITE} Try the Php version you input?"
read -p "You select number is: " select_swich_php
case $select_swich_php in
1)
	if [ ! -d ${php_install_dir}/${php_version[1]} ];then
		echo -e "${YELLOW}There is no ${php_version[1]} in your system, i will install it in ${php_install_dir}${WHITE}"	
		preinstall_php
		install_libmcrypt
		echo "/usr/local/lib" >> /etc/ld.so.conf && ldconfig
		pushd $src_dir
		php_install_dir_use="${php_install_dir}/${php_version[1]}" 
		[ ! -f ${php_bz[1]} ] && down_url ${php_url[1]} || echo -e "Download ${php_url[1]} Failed!!" 
		tar xjvf ${php_bz[1]}
		cd ${php_version[1]}
		config_php 
		add_php_boot
		popd
		copy_php_fpm
	else
		echo -e "${GREEN}${php_version[1]} is exits,now swich to it!${WHITE}"
		service php-fpm stop
		sleep 3
		killall php-fpm >/dev/null 2>&1
		sed -i 's#^prefix=*.*[0-9]$#prefix=\/usr\/local\/php\/php-5\.6\.30#g' /etc/init.d/php-fpm
		systemctl daemon-reload >/dev/null 2>&1 
		service php-fpm start
		ln -fs ${php_install_dir}/${php_version[1]}/bin/php /usr/bin/php
	fi
	;;		
2)
	if [ ! -d ${php_install_dir}/${php_version[2]} ];then
		preinstall_php
		install_libmcrypt
		pushd $src_dir
		echo "/usr/local/lib" >> /etc/ld.so.conf && ldconfig
		php_install_dir_use="${php_install_dir}/${php_version[2]}"
		[ ! -f ${php_bz[2]} ] && down_url ${php_url[2]} || echo -e "Download ${php_url[2]} Failed!!"
		tar xjvf ${php_bz[2]}
		cd ${php_version[2]}
		config_php
		add_php_boot
		popd
		copy_php_fpm
	else
		echo -e "${GREEN}${php_version[2]} is exits in system, now swich to it!${WHITE}"
		service php-fpm stop
		sleep 3
		killall php-fpm >/dev/null 2>&1
		sed -i 's#^prefix=*.*[0-9]$#prefix=\/usr\/local\/php\/php-7\.1\.6#g' /etc/init.d/php-fpm
		systemctl daemon-reload >/dev/null 2>&1
		service php-fpm start
		ln -fs ${php_install_dir}/${php_version[2]}/bin/php /usr/bin/php
	fi
	;;
3)
	. include/upgrade_php.sh
	;;
*)
	echo -e "${RED}Input error number!!${WHITE}"
	;;
esac
}
Menu_swich_php
