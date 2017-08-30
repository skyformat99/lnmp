#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
# Pureftp install shell script					    #
#####################################################################

#Def varible
ftp_url="https://download.pureftpd.org/pub/pure-ftpd/releases"
ftp_ver="pure-ftpd-1.0.46"
ftp_bz="${ftp_ver}.tar.bz2"
ftp_dir="/usr/local/pureftpd"
read -p "Please input ftp user acount:" ftp_user
read -p "Please input ftp user $ftp_user password:" ftp_pwd

wget ${ftp_url}/${ftp_bz}
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
echo "PureDB                      /usr/local/pureftpd/etc/pureftpd.pdb" >> /usr/local/pureftpd/etc/pure-ftpd.conf
echo "PIDFile                     /usr/local/pureftpd/var/run/pure-ftpd.pid" >> /usr/local/pureftpd/etc/pure-ftpd.conf
/usr/local/pureftpd/sbin/pure-ftpd /usr/local/pureftpd/etc/pure-ftpd.conf
echo -e "${ftp_pwd}\n${ftp_pwd}" | /usr/local/pureftpd/bin/pure-pw useradd $ftp_user  -uwww -d /data/wwwroot/
/usr/local/pureftpd/bin/pure-pw mkdb
/usr/local/pureftpd/bin/pure-pw list

