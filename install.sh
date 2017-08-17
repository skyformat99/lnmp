#!/bin/bash
clear
. include/common.sh
. include/public.sh
echo -e "$GREEN
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################"

#Lnmp main process
lnmp(){
. include/sysinfo.sh
. include/Menu.sh
. include/chk_install.sh
source /etc/profile
}


#run lnmp & create lnmp log
lnmp 2>&1 | tee  ./lnmp.log
echo -e "$WHITE"

. /etc/bashrc

