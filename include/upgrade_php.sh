#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################

pushd $src_dir
echo -e "$YELLOW"
while :;do echo
	if [ -z $php_version_input ];then
		read -p "Please input the PHP version you want upgrade to(example 7.1.7): " php_version_input
		echo -e "${WHITE}"
	else
		break
	fi
done
if [ -d ${php_install_dir}/php-${php_version_input}/etc ];then
	echo -e "${RED}php-${php_version_input} is exits, now swich to it!"
	ln -fs ${php_install_dir}/php-${php_version_input}/bin/php /usr/bin/php
	if [ -f /etc/init.d/php-fpm ];then
		service php-fpm stop
		sed -i 's#^prefix=*.*[0-9]$#prefix=\/usr\/local\/php\/php-'"${php_version_input}"'#g' /etc/init.d/php-fpm
		systemctl daemon-reload
		service php-fpm start
	fi
	exit
fi
php_url="http://mirrors.sohu.com/php/php-${php_version_input}.tar.bz2"
[ ! -f php-${php_version_input}.tar.bz2 ] && wget -c $php_url
[ ! -f php-${php_version_input}.tar.bz2 ] && echo -e "Download Php-$php_version_input failed!!" && exit

#Backup old php version
if [ -d $php_install_dir ];then
	service php-fpm stop
	mv $php_install_dir $php_old_dir
fi
echo -e "$WHITE"
popd
preinstall_php
install_libmcrypt

#Install PHP
install_php(){
php_install_dir_use="${php_install_dir}/php-${php_version_input}"
echo "/usr/local/lib" >> /etc/ld.so.conf && ldconfig
pushd $src_dir
tar xjf php-${php_version_input}.tar.bz2
cd php-${php_version_input}
config_php
add_php_boot
popd
copy_php_fpm
}
install_php
