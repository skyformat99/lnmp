#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
# Pureftp install shell script					    #
# Wed Aug 30 14:53:09 CST 2017					    #
#####################################################################

[ `id -u` -ne 0 ] && echo -e "\033[34m请使用ROOT权限运行$0!!\033[0m" && exit 1

clear
echo -e "\033[32m#########################################"
read -p "Please input ftp user acount:" ftp_user
echo
read -p "Please input ftp user $ftp_user password:" ftp_pwd
echo
read -p "Please input your ftpuser $ftp_user home dirctory: (Default /data/wwwroot)" ftp_user_home
echo -e "\033[32m#########################################\033[0m"

[ -f ftp_sbin ] && echo -e "\033[34mYou already installed pureftpd in you system!!\033[0m" && exit 0
cd $src_dir

wget ${ftp_url}/${ftp_bz}
[ $? -ne 0 ] && echo -e "\033[34m 下载${ftp_ver}失败,请把${ftp_url}上的其它文件URL写入到${0}里面的 ftp_ver !!\033[0m"
tar xjf ${ftp_bz}
cd $ftp_ver
./configure --prefix=${ftp_dir} \
--without-inetd \
--with-altlog \
--with-puredb \
--with-throttling \
--with-peruserlimits  \
--with-tls
make && make install
[ -d $ftp_dir ] && echo -e "\033[34mInstall $ftp_ver Failed,Please contact author!!\033[0m" && exit 1
rm -rf $ftp_bz
echo "PureDB                      ${ftp_dir}/etc/pureftpd.pdb" >> $ftp_conf
echo "PIDFile                     ${ftp_dir}/var/run/pure-ftpd.pid" >> $ftp_conf
$ftp_sbin $ftp_conf
echo -e "${ftp_pwd}\n${ftp_pwd}" | ${ftp_pw} useradd $ftp_user  -uwww -d $ftp_user_home
$ftp_pw mkdb

print "
ftp账户和对应目录为:
$ftp_pw list
密码为
"
echo -e "033[41m $ftp_pwd \033[0m"

#Add pureftpd to init.d
cp -rf init.d/pureftp.service /etc/init.d/pureftpd
chmod +x /etc/init.d/pureftpd
[[ "${os}" == "CentOS" ] && { chkconfig --add pureftpd; chkconfig pureftpd on; }
[[ "${os}" =~ ^Ubuntu$ ]] && { sed -i 's@^. /etc/rc.d/init.d/functions@. /lib/lsb/init-functions@' /etc/init.d/pureftpd; update-rc.d pureftpd defaults; }

popd
