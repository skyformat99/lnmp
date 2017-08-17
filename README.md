LNMP is a bash script for the installation of NGINX + PHP + MySQL.  
Author:	Hehl <1181554113@qq.com>  
Blog:	http://www.yunweijilu.com  
Begin in	20170510  
I want make the shell as my first gift for my daughter. ^_^ 

###Support OS:
- CentOS-6.x	;
- CentOS-7.x	;
- Ubuntu-14.x	;
- Ubuntu-16.x	;

###Software Version
 ---------------------- ------------------------------------------- 
|      NGINX          |       nginx-1.12.0    	                  
 --------------------- -------------------------- ----------------- 
|      PHP            |      php-5.6.30          |  php-7.1.6      
 --------------------- -------------------------- ----------------- 
|      MYSQL          |      mysql-5.6.36        |  mysql-5.7.16   
 ------------------------------------------------ ----------------- 

###Install Path
------------------------------------------------------------------
            |        installation    |        /usr/local/nginx      
            |        configuration   |        /usr/local/nginx/conf    
    Nginx   |        bin             |        /usr/local/nginx/sbin
            |        html            |        /data/wwwroot      
            |        logs            |        /data/wwwlogs     
-------------------------------------------------------------------
            |       installation     |         /usr/local/mysql          
    Mysql   |       configuration    |         /etc/my.cnf              
            |       bin              |         /usr/local/mysql/bin     
            |       data             |         /data/mysql        
-------------------------------------------------------------------
            |       installation     |        /usr/local/php          
    Php     |       configuration    |        /usr/local/php/etc    
            |       bin              |        /usr/local/php/bin        
-------------------------------------------------------------------

###Command Control
---
service  nginx    { start    | stop    | restart }  
service  mysqld   { start    | stop    | restart }  
service  php-fpm  { start    | stop    | restart }  
***
