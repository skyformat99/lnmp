#!/bin/bash
. include/common.sh
. include/public.sh
. include/sysinfo.sh >/dev/null 2>&1

clear
echo -e "${GREEN}
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#	Swich PHP version					    #
#####################################################################"

#Menu of swich PHP
Menu_swich_php(){
echo -e "${YELLOW}Please select PHP version you want swich to?"
echo
echo -e "${YELLOW}1)${WHITE} Php-5.6.30;"
echo -e "${YELLOW}2)${WHITE} Php-7.1.6;"
echo -e "${YELLOW}3)${WHITE} Try the Php version you inpurt;"
read -p ""You select number is: " select_swich_php
case $select_swich_php in
1)
	

