#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################

preinstall_php
install_libmcrypt

#Install PHP
install_php(){
echo "/usr/local/lib" >> /etc/ld.so.conf && ldconfig
pushd $src_dir
if [ -z $php_version_select -o $php_version_select -eq 1 ];then
	[ ! -f ${php_bz[1]} ] && down_url ${php_url[1]} || echo -e "Download ${php_url[1]} Failed!!"
	tar xjvf ${php_bz[1]}
	cd ${php_version[1]}
else
	[ ! -f ${php_bz[2]} ] && down_url ${php_url[2]} || echo -e "Download ${php_url[2]} Failed!!"
	tar xjvf ${php_bz[2]}
	cd ${php_version[2]}
fi
config_php
add_php_boot
popd
copy_php_fpm
add_phpinfo
}
install_php
