#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################

#Ngx URL you select version
pushd $src_dir
echo -e "$YELLOW"
read -p "Please input the nginx version you want upgrade to(example 1.12.1):  " ngx_version_input
if [[ ! $ngx_version_input =~ ^[0-9]$ ]];then
	echo -e "${RED}Error Nginx versions!!"
	exit 0
fi
ngx_url="http://nginx.org/download/nginx-${ngx_version_input}.tar.gz"

#Backup old nginx version
if [ -d $ngx_dir ];then
	mv $ngx_dir $ngx_old_dir
fi

#Download nginx
echo -e "$WHITE"
wget -c $ngx_url
[ ! -f nginx-${ngx_version_input}.tar.gz ] && echo -e "${RED}Download nginx-${ngx_version_input} failed,Please input a correct version!" && exit
popd

#Install necessary depends
echo -e "$WHITE"
echo -e "OS is ${RED}${os}"
echo -e "$WHITE"
[ "$os" == "centos" ] && yum  install -y iptables-services mlocate net-tools bzip2 autoconf make cmake  gcc gcc-c++ zlib zlib-devel screen psmisc
[ "$os" == "ubuntu" ] && apt-get update -y  && apt-get install -y -f build-essential mlocate net-tools bzip2 autoconf make cmake  gcc screen psmisc

#Install zlib for ubuntu
install_zlib(){
pushd $src_dir
tar xf zlib-1.2.11.tar.xz && cd zlib-1.2.11
./configure
make && make install
popd
}
install_zlib

#install jemalloc for nginx and mysql
install_jemalloc(){
pushd $src_dir
tar xjf ${jemalloc}.tar.bz2 && cd $jemalloc
./configure --prefix=/usr/local/jemalloc --libdir=/usr/local/lib
make && make install
make clean
popd
echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf
/sbin/ldconfig
}
install_jemalloc

#install openssl module
install_openssl(){
pushd $src_dir
tar zxf ${openssl}.tar.gz
./configure
make && make install
popd
}
install_openssl

#install pcre
install_pcre(){
pushd $src_dir
tar xjf ${pcre}.tar.bz2 &&  cd $pcre
./configure
make && make install
popd
}
install_pcre

ngx_install(){
pushd $src_dir
tar zxf nginx-${ngx_version_input}.tar.gz
useradd  -M -s /sbin/nologin $ngx_user >/dev/null 2>&1
tar xzf nginx-${ngx_version_input}.tar.gz
cd nginx-${ngx_version_input}
. ./configure --prefix=$ngx_dir \
--user=$ngx_user \
--group=$ngx_group \
--with-http_stub_status_module \
--with-http_v2_module \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-openssl=../${openssl} \
--with-pcre=../${pcre} \
--with-pcre-jit \
--with-ld-opt='-ljemalloc' 
make && make install && echo -e "$YELLOW Nginx install successful!" || echo -e "$RED Install Nginx failed, Please check error number!!"
popd >/dev/null 2>&1
}
ngx_install

#Nginx setting
ngx_settings(){
mkdir -p ${wwwroot_dir}/default $www_logs ${ngx_dir}/conf/vhost
chown -R ${ngx_user}.${ngx_group} $wwwroot_dir $www_logs
rm -rf /usr/bin/nginx && ln -s $ngx_dir/sbin/nginx /usr/bin/nginx
cp ./conf/nginx.conf $ngx_dir/conf
rm -rf $src_dir/$ngx_version $src_dir/$openssl $src_dir/$pcre $src_dir/$jemalloc
echo -e "$WHITE"
[ "$os" == "centos" ] && { cp -f init.d/nginx-init-centos /etc/init.d/nginx ; chkconfig  --level 2345 nginx on && chkconfig save ; }
[ "$os" == "ubuntu" ] && { cp -f init.d/nginx-init-ubuntu /etc/init.d/nginx && chmod a+x /etc/init.d/nginx ; update-rc.d nginx defaults; }
echo "############################################If you see this word, Nginx works!!!################################" > $wwwroot_dir/default/index.html

#Don't use selinux
close_selinux(){
[ "$os" == "centos" ] && [ -f /etc/selinux/config ] &&  sed -i "s#SELINUX=enforcing#SELINUX=disabled#g"  /etc/selinux/config && setenforce 0
}
close_selinux

#Add open tcp 80 port to iptables list
centos_iptables(){
if [ "$os" == "centos" ];then
systemctl stop iptables.service
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
systemctl stop firewalld.service 2>/dev/null
systemctl disable firewalld.service 2>/dev/null
systemctl start iptables.service 2>/dev/null
service iptables save
systemctl stop iptables.service
fi
}
centos_iptables

service nginx restart
[ "$os" == "ubuntu" ] && service ufw stop
}
ngx_settings
