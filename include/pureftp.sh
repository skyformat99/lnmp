#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
# Pureftp install shell script					    #
# Wed Aug 30 14:53:09 CST 2017					    #
#####################################################################

clear

if [ $os == "centos" ];then
	yum install gcc gcc+ cmake make openssl openssl-dev -y
elif [ "$os" == "ubuntu" ];then
	apt-get install gcc gcc+ cmake make -y
	apt-get install -y  openssl
	apt-get install -y libssl-dev
fi
pushd $src_dir
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
[ ! -d $ftp_dir ] && echo -e "\033[34mInstall $ftp_ver Failed,Please contact author!!\033[0m" && exit 0
popd

#Add pureftpd to init.d
cp -rf init.d/pureftp.service /etc/init.d/pureftpd
chmod +x /etc/init.d/pureftpd
[[ "${os}" == "centos" ]] && { chkconfig --add pureftpd; chkconfig pureftpd on; }
[[ "${os}" == "ubuntu" ]] && { sed -i 's@^. /etc/rc.d/init.d/functions@. /lib/lsb/init-functions@' /etc/init.d/pureftpd; update-rc.d pureftpd defaults; }

echo "PureDB                      ${ftp_dir}/etc/pureftpd.pdb" >> $ftp_conf
echo "PIDFile                     /var/run/pure-ftpd.pid" >> $ftp_conf
service pureftpd start
#$ftp_sbin $ftp_conf
[ `awk -F: '{print $1}' /etc/passwd | grep -e ^www$ | wc -l` -ne 1 ] && useradd www -s /bin/nologin
[ ! -d $ftp_user_home ] && mkdir -p $ftp_user_home && chown -R www.www $ftp_user_home
echo -e "${ftp_pwd}\n${ftp_pwd}" | $ftp_pw useradd $ftp_user  -u www -d $ftp_user_home
$ftp_pw mkdb

echo "ftp账户和目录为:"
$ftp_pw list
echo -e "\033[41m Ftp密码:$ftp_pwd \033[0m"

