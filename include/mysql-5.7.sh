#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################"

clear

before_install_mysql

mysql_install_5.7(){
if [[ $os == "centos" ]];then
	if [[ -z "$mysql_install_wayway" || "$mysql_install_wayway" -eq "1" ]];then
		mysql_install_5.7_bin
	elif [[ "$mysql_install_wayway" -eq "2" ]];then
		mysql_install_5.7_cmake
	else
		echo "Input error for xinstall mysql way!"
		exit
	fi
elif [[ $os == "ubuntu" ]];then
	pushd $src_dir
	apt-cache search libaio && apt-get install -y libaio1 libaio-dev
	if [ "$mysql_chk_u" ==  "0" ];then
		groupadd mysql
		useradd -r -g mysql -s /bin/false mysql
	fi
		apt-get update
		test -f ${mysql_gz[3]} || wget --no-check-certificate ${mysql_down_url[2]}/${mysql_gz[3]}
	if [ ! -d ${mysql_dir[3]} ];then
		echo -e "Now is extracting mysql!"
		tar zxf ${mysql_gz[3]}
	fi
	echo -e "Now copy mysql to $mysql_local"
	mv -f ${mysql_dir[3]} $mysql_local
	mkdir ${mysql_local}/mysql-files
	chmod 750 ${mysql_local}/mysql-files
	chown -R mysql.mysql $mysql_local
	popd
fi

#create data dir; set directory privileges; mysql initialize
[ ! -d $mysql_data  ] && mkdir -p $mysql_data && chown -R mysql.mysql /data/mysql 
cp -rf conf/my.cnf_mysql5.7 /etc/my.cnf
/usr/local/mysql/bin/mysqld --initialize-insecure --user=mysql --basedir=$mysql_local --datadir=$mysql_data
cp -rf $mysql_local/support-files/mysql.server /etc/init.d/mysqld

#set boot start
[ -f /etc/init.d/mysqld ] && chmod +x /etc/init.d/mysqld
[ $os == "centos" ] && chkconfig --add mysqld && chkconfig mysqld on
[ $os == "ubuntu" ] && update-rc.d mysqld defaults

/etc/init.d/mysqld stop >/dev/null 2>&1
[ -e /usr/local/mysql/my.cnf ] && rm -rf /usr/local/mysql/my.cnf 
/etc/init.d/mysqld start
mysql_grant

echo "/usr/local/mysql" > /etc/ld.so.conf.d/mysql.conf
ldconfig
}
mysql_install_5.7
