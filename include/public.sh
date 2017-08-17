#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
# Desribtion:		Public Function				    #
#####################################################################

#Sync time
sync_time(){
case $sync_time_yn in
y|Y)
	. ./include/sync_time.sh
;;
*)
	echo "Not install or input wrong value for sync time!"
;;
esac
}

#Download
down_url(){
wget -c $*
}

#Mysql Insltall Way
mysql_install_way(){
echo
echo  -e "${YELLOW}How to install Mysql Server?( Default 1 ) :
		$RED 1)$WHITE Use Binary File;(Option)
		$RED 2)$WHITE Use Build Source Code;(Need more time)"
echo
read -p "You select the number to install mysql:  " mysql_install_wayway
}

#Before install mysql
before_install_mysql(){
cp -f conf/my.cnf /etc
[ "$mysql_chk_u" == "0" ] && useradd -M -s /sbin/nolgin mysql
[ -f /etc/my.cnf ] && mv -f /etc/my.cnf /etc/my.cnf_`date +%Y%m%d%H%M`
if [ -d $mysql_local ];then
	/etc/init.d/mysqld start >/dev/null 2>&1
	$MYSQLDUMP -u$MYSQLUSR -p${mysql_root_pass} --all-databases > $mysql_data_backup
	/etc/init.d/mysqld stop && echo "Now is stoping mysql..."
	mv -f $mysql_local $mysql_old_dir
fi
[ -d $mysql_data ] && mv -f $mysql_data $data_backup_dir/mysql_`date +%Y%m%d%H%M`
}

#Install MYSQL
mysql_install_centos_cmake(){
yum -y install make gcc-c++ cmake bison-devel  ncurses-devel
pushd $src_dir 
test  -f ${mysql_gz[1]} || wget -c ${mysql_down_url[1]}/${mysql_gz[1]}
echo -e "Now extarting ${mysql_gz[1]}"
tar  zxvf ${mysql_gz[1]}
cd ${mysql_version[1]}
#make clean && rm -rf CMakeCache.txt
cmake . -DCMAKE_INSTALL_PREFIX=$mysql_local \
-DMYSQL_DATADIR=$mysql_data \
-DSYSCONFDIR=/etc \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8mb4 \
-DDEFAULT_COLLATION=utf8mb4_general_ci
make -j `grep processor /proc/cpuinfo | wc -l` && make install
popd
}

#Modify password then Grant privileges
mysql_grant(){
$mysql_admin -uroot password "${mysql_root_pass}"
cp -f include/grant.sql include/grant.sql.bak
sed -i 's/mysql_pwd/'"${mysql_root_pass}"'/g' include/grant.sql
cat include/grant.sql | $mysql_cmd -uroot -p${mysql_root_pass}
mv -f include/grant.sql.bak include/grant.sql
$mysql_cmd -uroot -p${mysql_root_pass} <<EOF
drop database if exists test;
delete from mysql.user where not (user='root');
delete from mysql.db where user='';
flush privileges;
exit
EOF
[ -f $mysql_data_backup ] && $mysql_cmd -u$MYSQLUSR -p$mysql_root_pass < $mysql_data_backup
}

mysql_install_boot(){
cd $mysql_local
chown -R mysql:mysql $mysql_local && chmod 755 $mysql_local/bin/*
cp -rf ${mysql_local}/support-files/mysql.server /etc/init.d/mysqld && chmod 755 /etc/init.d/mysqld
sed -i "s:^basedir=.*:basedir=$mysql_local:g" /etc/init.d/mysqld
sed -i "s:^datadir=.*:datadir=$mysql_data:g" /etc/init.d/mysqld
echo -e "$WHITE"
[ ! -d /data/mysql  ] && mkdir -p /data/mysql && chown -R mysql.mysql /data/mysql
[ -d /var/lib/mysql ] && rm -rf /var/lib/mysql
cd -
cp -rf conf/my.cnf /etc
$mysql_local/scripts/mysql_install_db --basedir=$mysql_local --datadir=$mysql_data --user=mysql
#$mysql_local/bin/mysql_secure_installation --basedir=$mysql_local --datadir=$mysql_data --user=mysql
[ $os == "centos" ] && chkconfig mysqld on && chkconfig save
[ $os == "ubuntu" ] && update-rc.d mysqld defaults

#Add mysql to enviroment path
echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/mysql/bin" >> /etc/profile

/etc/init.d/mysqld start
mysql_grant
}

#install mysql-5.7.16 by cmake
mysql_install_5.7_cmake(){
pushd $src_dir
useradd -M -s /sbin/nologin mysql
yum install -y gcc gcc-c++ ncurses ncurses-devel cmake libaio
test -f ${mysql_version[4]}.tar.gz || wget -c ${mysql_down_url[2]}/${mysql_gz[4]}
tar zxvf ${mysql_gz[4]}
cd ${mysql_version[4]}
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/data/mysql \
-DDOWNLOAD_BOOST=1 \
-DWITH_BOOST=boost/boost_1_59_0 \
-DSYSCONFDIR=/etc \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DENABLE_DTRACE=0 \
-DDEFAULT_CHARSET=utf8mb4 \
-DDEFAULT_COLLATION=utf8mb4_general_ci \
-DWITH_EMBEDDED_SERVER=1
make -j `grep processor /proc/cpuinfo | wc -l`
make install
echo -e "$WHITE"
popd
cp -rf $mysql_local/support-files/mysql.server /etc/init.d/mysqld
}

#Install mysql-5.6 by binary file
mysql_install_5.6_bin(){
pushd $src_dir
yum install -y libaio
test  -f ${mysql_gz[2]} || wget -c ${mysql_down_url[1]}/${mysql_gz[2]}
[ $? -ne "0" ] && echo "Download ${mysql_gz[2]} Failed,Please contact Author." && exit
[ ! -d ${mysql_dir[2]} ] && tar zxvf ${mysql_gz[2]}
mv -f ${mysql_version[2]} $mysql_local
[ -d /usr/share/mysql ] && mkdir /usr/share/mysql && cp $mysql_local/share/errmsg.sys /usr/share/mysql
[ -f /etc/mysql/my.cnf ] && mv /etc/mysql/my.cnf /etc/mysql/my.cnf_$RANDOM
popd
}

#Install mysql-5.7 by binary file
mysql_install_5.7_bin(){
pushd $src_dir
yum install -y libaio
test  -f ${mysql_gz[3]} || wget -c ${mysql_down_url[2]}/${mysql_gz[3]}
[ $? -ne "0" ] && echo "Download ${mysql_gz[3]} Failed,Please contact Author." && exit
[ ! -d ${mysql_dir[3]} ] && tar zxvf ${mysql_gz[3]}
mv -f ${mysql_dir[3]} $mysql_local
[ -d /usr/share/mysql ] && mkdir /usr/share/mysql && cp $mysql_local/share/errmsg.sys /usr/share/mysql
[ -f /etc/mysql/my.cnf ] && mv /etc/mysql/my.cnf /etc/mysql/my.cnf_$RANDOM
popd
}

#Prepare install php
preinstall_php(){
[ $php_user == '0' ] && useradd -M -s /sbin/nologin www
if [ $os == "centos" ];then
yum install -y gcc gcc-c++ libxml2 libxml2-devel libjpeg-devel libpng-devel freetype-devel openssl-devel libcurl-devel libmcrypt libmcrypt-devel libicu-devel libxslt-devel
elif [ $os == "ubuntu" ];then
apt-get update
apt-get install  libxml2  libxml2-dev -y
apt-get install  openssl libssl-dev -y
apt-get install  curl libcurl4-gnutls-dev -y
apt-get install libjpeg-dev libpng12-dev   libxpm-dev libfreetype6-dev  libmcrypt-dev  libmysql++-dev  libxslt1-dev  libicu-dev  -y 
ln -sf /usr/lib/x86_64-linux-gnu/libssl.so  /usr/lib
fi
}

#Install libmcrypt
install_libmcrypt(){
pushd $src_dir
tar xzf ${libmcrypt}.tar.gz && cd $libmcrypt
./configure
make && make install
popd
}

#Configure for php
config_php(){
./configure --prefix=$php_install_dir --with-config-file-path=$php_install_dir/etc \
--with-config-file-scan-dir=$php_install_dir/etc/php.d \
--with-fpm-user=php --with-fpm-group=www --enable-fpm --enable-opcache --disable-fileinfo \
--with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd \
--with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib \
--with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-exif \
--enable-sysvsem --enable-inline-optimization --with-curl=/usr/local --enable-mbregex \
--enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl \
--with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-ftp --enable-intl --with-xsl \
--with-gettext --enable-zip --enable-soap --disable-debug
make ZEND_EXTRA_LIBS='-liconv'
ln -s /usr/local/lib/libiconv.so.2 /usr/lib64/
make install && cp -f php.ini-production $php_etc/php.ini && cp -f sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod +x /etc/init.d/php-fpm
}

#Add php boot
add_php_boot(){
if [[ $os == "centos" ]];then
	chkconfig  php-fpm on  && chkconfig save
elif	[[ $os == "ubuntu" ]];then
	update-rc.d php-fpm defaults
fi

if [ -e $php_install_dir/bin/phpize ];then
	echo -e "Php install successful!"
else
	echo -e "Php install failed, Please contact author."
	kill -9 $$
fi
ln -s /usr/local/php/bin/php /usr/bin/php
}

#Copy php-fpm.conf
copy_php_fpm(){
cp -f conf/php-fpm.conf $php_etc
[ ! -d ${wwwroot_dir} ] && mkdir -p ${wwwroot_dir}/default
service php-fpm restart
rm -rf $src_dir/$libmcrypt $src_dir/${php_version[1]}
}

#Add phpinfo
add_phpinfo(){
[ ! -d ${wwwroot_dir}/default ] && mkdir -p ${wwwroot_dir}/default && chown -R www.www ${wwwroot_dir}/default
echo "<?php phpinfo();?>" > ${wwwroot_dir}/default/index.php
echo "It works!" >${wwwroot_dir}/default/index.html
}

