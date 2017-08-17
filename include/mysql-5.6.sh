#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################

clear

before_install_mysql

install_mysql_5.6(){
if [ $os == "centos" ];then
	if [[ -z "$mysql_install_wayway" || "$mysql_install_wayway" -eq "1" ]];then
		mysql_install_5.6_bin
	elif [[ "$mysql_install_wayway" -eq "2" ]];then
		mysql_install_centos_cmake
	else
		echo "Input error for install Mysql way!"
		exit
	fi
	mysql_install_boot
elif [ $os == "ubuntu" ];then
apt-cache search libaio && apt-get install -y libaio1 libaio-dev
	if [ "$mysql_chk_u" ==  "0" ];then
		groupadd mysql
		useradd -r -g mysql -s /bin/false mysql
	fi
	pushd $src_dir
	test  -f ${mysql_gz[2]} || wget -c ${mysql_down_url[1]}/${mysql_gz[2]}
	[ ! -d ${mysql_dir[2]} ] && tar zxvf ${mysql_gz[2]}
	mv -f ${mysql_version[2]} $mysql_local
	[ -d /usr/share/mysql ] && mkdir /usr/share/mysql && cp $mysql_local/share/errmsg.sys /usr/share/mysql
	[ -f /etc/mysql/my.cnf ] && mv /etc/mysql/my.cnf /etc/mysql/my.cnf_$RANDOM
	popd
	mysql_install_boot
fi
}
install_mysql_5.6
