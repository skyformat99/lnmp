#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################

pushd $src_dir
echo -e "$YELLOW"
read -p "Please input the PHP version you want upgrade to(example 7.1.7): " php_version_input
php_url="http://mirrors.sohu.com/php/php-${php_version_input}.tar.bz2"
wget -c $php_url
[ -f $php_url ] && echo -e "Download Php-$php_version_input failed!!" && exit

#Backup old mysql version
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
echo "/usr/local/lib" >> /etc/ld.so.conf && ldconfig
pushd $src_dir
tar xjf php-${php_version_input}.tar.bz2
cd php-${php_version_input}
config_php
add_php_boot
copy_php_fpm
popd
}
install_php

add_phpinfo
