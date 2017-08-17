#!/bin/bash
#####################################################################
# LNMP is a bash script for the installation of Nginx + PHP + MySQL.#
# Author        Hehl <1181554113@qq.com>                            #
# Blog          Http://www.yunweijilu.com                           #
# Describtion:   Common Defined Variables			    #
#####################################################################

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:~/bin

#Config echo color
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
WHITE='\033[0;0m'

#Check root privileges
[ $(id -u) != 0 ] && { echo -e "$RED You need root privileges to run it!" ; exit 1;}

#current dir
src_dir=`pwd`/src

#Sysbit variable
sysbit=`uname -a | grep 64 | wc -l`
[ $sysbit -eq "1" ] && sys_bit="x86_64" || sys_bit="i686"

#define nginx path
ngx_dir="/usr/local/nginx"
ngx_version="nginx-1.12.0"
ngx_gz="${src_dir}/nginx-1.12.0.tar.gz"
ngx_user="www"
ngx_group="www"
pcre='pcre-8.39'
openssl='openssl-1.0.1t'
jemalloc='jemalloc-3.6.0'
zlib="zlib-1.2.11"
wwwroot_dir="/data/wwwroot"
www_logs="/data/wwwlogs"

#Define MYSQL path
mysql_down_url[1]="https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-5.6"
mysql_down_url[2]="https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-5.7"
mysql_version[1]="mysql-5.6.36"
mysql_version[2]="mysql-5.6.36-linux-glibc2.5-${sys_bit}"
mysql_version[4]="mysql-5.7.18"
mysql_gz[1]="${mysql_version[1]}.tar.gz"
mysql_gz[2]="${mysql_version[1]}-linux-glibc2.5-${sys_bit}.tar.gz"
mysql_gz[3]="${mysql_version[4]}-linux-glibc2.5-${sys_bit}.tar.gz"
mysql_gz[4]="mysql-boost-5.7.18.tar.gz"
mysql_dir[2]="${mysql_version[1]}-linux-glibc2.5-${sys_bit}"
mysql_dir[3]="${mysql_version[4]}-linux-glibc2.5-${sys_bit}"
mysql_data="/data/mysql"
mysql_local="/usr/local/mysql"
mysql_cmd="/usr/local/mysql/bin/mysql"
mysql_chk_u=`grep mysql /etc/passwd | wc -l`

#Define PHP
libmcrypt="libmcrypt-2.5.7"
php_version[1]="php-5.6.30"
php_version[2]="php-7.1.6"
php_bz[1]="${php_version[1]}.tar.bz2"
php_bz[2]="${php_version[2]}.tar.bz2"
php_url[1]="http://mirrors.sohu.com/php/${php_bz[1]}"
php_url[2]="http://mirrors.sohu.com/php/${php_bz[2]}"
php_install_dir="/usr/local/php"
php_etc="/usr/local/php/etc"
php_user=`grep www /etc/passwd | wc -l`

#Redis 
redis_gz="redis-4.0.0.tar.gz"
redis_version="redis-4.0.0"
redis_install_dir="/usr/local/redis"
redis_conf_dir="/etc/redis"

#Data backup
data_backup_dir="/data/backup"
mysql_data_backup="/data/backup/mysql_`date +%Y%m%d`.sql"
ngx_old_dir="/usr/local/nginx_old_`date +%Y%m%d%H%M`"
mysql_old_dir="/usr/local/mysql_old_`date +%Y%m%d%H%M`"
php_old_dir="/usr/local/php_old_`date +%Y%m%d%H%M`"
MYSQLUSR="root"
MYSQLDUMP="/usr/local/mysql/bin/mysqldump"
mysql_admin="/usr/local/mysql/bin/mysqladmin"

