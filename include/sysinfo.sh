#!/bin/bash

time_begin=$(date +%s)

echo -e "$WHITE"
echo "Your hardware & OS information is below:"

#Get ip
get_ip(){
ip=$(ip addr | grep "scope global" | awk  '{ print $2 }' | cut -d"/" -f 1)
echo "IP :$ip"
}

#get cpu info
cpu_info(){
cpu_info=`cat /proc/cpuinfo  | grep "model name" | uniq | awk -F: '{print $2}'`
echo "CPU:$cpu_info"
}

#get memory size
mem_info(){
mem_total=`free -m | grep "Mem" | awk '{print $2}'`
echo "Memory:$mem_total MB"
}

#Check_os & sysbit
chk_os(){
if [ -f /etc/redhat-release ];then
	os_cat=`cut -d'.' -f1,2 /etc/redhat-release`
	echo "OS : $os_cat"
else
	os_cat=`cut -d'.' -f1,2 /etc/issue | tr -d '\n'`
	[ -f /etc/issue ]
	echo "OS : $os_cat"
fi
if [ -f /etc/issue -o -f /etc/redhat-release ];then
	[ `grep -i ubuntu /etc/issue | wc -l` -eq "1" -o `grep -i debian /etc/issue | wc -l` -eq "1" ] && os=ubuntu
	[ `grep -i cent /etc/issue | wc -l` -eq "1" ]  && os=centos
else
	echo "Unsupport System!!!"
	exit
fi
sysbit=`uname -a | grep 64 | wc -l`
[ $sysbit -eq "1" ] && echo "Sysbit: 64bit" || echo "Sysbit: 32bit"
}

#Don't use selinux
close_selinux(){
[ -f /etc/selinux/config ] &&  sed -i "s#SELINUX=enforcing#SELINUX=disabled#g"  /etc/selinux/config && setenforce 0
}

chk_disk(){
disk_free=`df -h | grep /dev | grep \/$ |awk '{print $4}'`
echo "Disk free size:	$disk_free"
}

#Check date time
chk_date(){
echo "Date:`date`"
}
#Display sysinfo
sysinfo(){
echo -e "$RED"
echo "--------------------------------------------------------------------"
get_ip
cpu_info
mem_info
chk_os
chk_disk
chk_date
echo "--------------------------------------------------------------------"
}
sysinfo

