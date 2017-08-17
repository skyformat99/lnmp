#!/bin/bash

#Set Aliyun Mirror as Sys repo
set_repo(){
if [ $os == "centos" ];then
	cp -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bk
	os_release=`cat /etc/centos-release | tr -d "CentOS Linux release" | awk -F'.' '{print $1}'`
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-${os_release}.repo  >/dev/null 2>&1 && echo  "Set Aliyun Repo success!"
	#yum makecache
elif [ $os == "ubuntu" ];then
	cp -f /etc/apt/sources.list /etc/apt/sources.list.bak
	echo "Only backup /etc/apt/sources.list "
	#cp -f src/sources.list /etc/apt/sources.list && apt-get update && echo "Set Aliyun Repo success!"
fi
}
set_repo
