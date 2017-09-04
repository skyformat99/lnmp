# 欢迎使用 LNMP一键部署脚本
---
**一.简介**
LNMP一键部署脚本是一键部署web环境所用，非常适合网站运维人员，开发人员在Linux系统中部署web环境。

您可以使用LNMP一键部署脚本：
> * 自动部署Nginx,Mysql,Php
> * 备份数据库
> * 升级软件版本
> * 添加虚拟站点和目录

**二.文件目录**

```
conf                                   #软件配置文件夹
include                                #系统软件部署脚本文件夹
init.d                                 #服务脚本文件夹
src                                    #软件包文件夹
db_backup_import.sh                    #数据导出和导入脚本
install.sh                             #LNMP一键部署脚本
uninstall.sh                           #一键卸载脚本
upgrade.sh                             #一键升级脚本
vhost.sh                               #一键增加Nginx虚拟站点和网站目录

```
**三.安装截图**

### 文件

![安装菜单][1]

### 安装

![菜单一][2]

![菜单二][3]

### 安装完成

![完成][4]

### 站点添加

![添加站点][5]

### 数据库提示

![数据库提示][6]

### 数据库备份

![数据库备份][7]

### LNMP卸载

![uninstall][8]

[1]: http://lnmp.yunweijilu.com/blog/img/2017/0904/file.png
[2]: http://lnmp.yunweijilu.com/blog/img/2017/0904/menu1.png
[3]: http://lnmp.yunweijilu.com/blog/img/2017/0904/menu2.png
[4]: http://lnmp.yunweijilu.com/blog/img/2017/0904/finished.png
[5]: http://lnmp.yunweijilu.com/blog/img/2017/0904/vhost.png
[6]: http://lnmp.yunweijilu.com/blog/img/2017/0904/db1.png
[7]: http://lnmp.yunweijilu.com/blog/img/2017/0904/db2.png
[8]: http://lnmp.yunweijilu.com/blog/img/2017/0904/uninstall.png
