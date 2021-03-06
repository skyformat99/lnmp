#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################

#Install necessary depends
echo -e "$WHITE"
echo -e "OS is ${RED}${os}"
echo -e "$WHITE"
[ "$os" == "centos" ] && yum  install -y iptables-services mlocate net-tools bzip2 autoconf make cmake  gcc gcc-c++ zlib zlib-devel screen psmisc
[ "$os" == "ubuntu" ] && apt-get update -y  && apt-get install -y -f build-essential mlocate net-tools bzip2 autoconf make cmake  gcc screen psmisc

install_zlib

install_jemalloc

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
tar zxf $ngx_gz
useradd  -M -s /sbin/nologin $ngx_user >/dev/null 2>&1
cd $ngx_version
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
rm -rf $src_dir/$ngx_version $src_dir/$openssl $src_dir/$pcre $src_dir/$jemalloc $src_dir/$zlib
echo -e "$WHITE"
[ "$os" == "centos" ] && { cp -f init.d/nginx-init-centos /etc/init.d/nginx ; chkconfig  --level 2345 nginx on && chkconfig save ; }
[ "$os" == "ubuntu" ] && { cp -f init.d/nginx-init-ubuntu /etc/init.d/nginx && chmod a+x /etc/init.d/nginx ; update-rc.d nginx defaults; }
echo "############################################Nginx works!!!################################" > $wwwroot_dir/default/index.html

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
nginx -s reload
[ $os == "ubuntu" ] && service ufw stop
}
ngx_settings
