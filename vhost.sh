#!/bin/bash
. include/common.sh
clear
echo -e "${GREEN}
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
#####################################################################"

#Add vhost
vhost_add(){
	echo -e "$YELLOW"
        read -p "Please input your domain name as your htdoc! (example: yunweijilu.com)  " domain_name
        mkdir -p ${wwwroot_dir}/${domain_name}
        chown -R $ngx_user:$ngx_group ${wwwroot_dir}/${domain_name}
        cp -f conf/nginx_vhost.conf  ${ngx_dir}/conf/vhost/${domain_name}.conf
        sed -i "s/domain/${domain_name}/g" ${ngx_dir}/conf/vhost/${domain_name}.conf
        echo -e "$GREEN"
        [ -d ${wwwroot_dir}/${domain_name} ] && echo -e "Created ${wwwroot_dir}/${domain_name} success!"
        [ -f ${ngx_dir}/conf/vhost/${domain_name}.conf ] && echo -e "Created ${ngx_dir}/conf/vhost/${domain_name}.conf success!"
}

#Delete vhost
vhost_del(){
	echo -e "${YELLOW}"
	read -p "Please input your domain name which you want delete! (example: yunweijilu.com)  " domain_name
	if [  -z "$domain_name" ];then
		echo
		echo -e "${WHITE}You did not intput anything."
	elif [  -f ${ngx_dir}/conf/vhost/${domain_name}.conf ];then
		[ ! -d  ${data_backup_dir} ] && mkdir -p ${data_backup_dir}
		mv ${wwwroot_dir}/${domain_name} ${data_backup_dir}/${domain_name}_`date +%m%d%H%M`
		mv ${ngx_dir}/conf/vhost/${domain_name}.conf ${data_backup_dir}/${domain_name}.conf_`date +%m%d%H%M`
		echo -e "$GREEN"
		[ ! -d ${wwwroot_dir}/${domain_name} ] && echo -e "Delete ${wwwroot_dir}/${domain_name} success!"
		[ ! -f ${ngx_dir}/conf/vhost/${domain_name}.conf ] && echo -e "Delete ${ngx_dir}/conf/vhost/${domain_name}.conf success!"
	else
		echo
		echo  -e "${RED}You input a incroccet domain name,Please check it..."
	fi
}

#Vhost Menu
if [ ! -f ${ngx_dir}/conf/nginx.conf ];then
	echo -e "${RED}Please check if you had installed Nginx!!"
else
	if	[[ "$1" == "add" && -z $2 ]];then
		echo
		vhost_add
	elif	[[ "$1" == "del"  && -z $2 ]];then
		echo
		echo -e "${WHITE}You select delete vhost for nginx, your website data backup in $data_backup_dir"
		vhost_del
	else
		echo
		echo -e "${WHITE}Usage: $0 {add|del}"
	fi
fi
echo -e "${WHITE}"
