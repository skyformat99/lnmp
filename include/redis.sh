#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################

pushd $src_dir
[ ! -d $redis_version ] &&  tar zxf $redis_gz
cp -rf $redis_version $redis_install_dir
cd $redis_install_dir
make
echo never > /sys/kernel/mm/transparent_hugepage/enabled
[ ! -L /usr/local/bin/redis-server ] && ln -fs ${redis_install_dir}/src/redis-server /usr/local/bin/redis-server
[ ! -L /usr/local/bin/redis-cli ] && ln -fs ${redis_install_dir}/src/redis-cli	/usr/local/bin/redis-cli
cd -
cd ..
cp -rf init.d/redis /etc/init.d/redis
if [ ! -f /etc/redis/redis.conf ];then
	mkdir /etc/redis >/dev/null 2>&1
	cp -f $redis_install_dir/redis.conf /etc/redis/6379.conf >/dev/null 2>&1
	sed -i 's@daemonize no@daemonize yes@g' /etc/redis/6379.conf
fi
chmod 755 /etc/init.d/redis
if [ $os == "centos" ];then
	chkconfig redis on && chkconfig save
	service redis start
	[ -f /etc/redis/6379.conf ] && echo "Install Redis successful!"
	popd
elif [ $os == "ubuntu" ];then
	systemctl daemon-reload 2>/dev/null
	service redis start
	update-rc.d redis defaults >/dev/null
	popd
fi
