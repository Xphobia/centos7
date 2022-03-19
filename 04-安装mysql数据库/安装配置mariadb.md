

1. 安装命令
```
    yum -y install mariadb mariadb-server
```

2. 启动MariaDB
```
[root@localhost ~]# systemctl start mariadb
[root@localhost ~]# systemctl status mariadb
● mariadb.service - MariaDB database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
   Active: active (running) since Sun 2022-03-20 02:10:41 CST; 1s ago
  Process: 3055 ExecStartPost=/usr/libexec/mariadb-wait-ready $MAINPID (code=exited, status=0/SUCCESS)
  Process: 2971 ExecStartPre=/usr/libexec/mariadb-prepare-db-dir %n (code=exited, status=0/SUCCESS)
 Main PID: 3053 (mysqld_safe)
   CGroup: /system.slice/mariadb.service
           ├─3053 /bin/sh /usr/bin/mysqld_safe --basedir=/usr
           └─3218 /usr/libexec/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mysql/plugin --log-error=/var/log/mariadb/mariadb.log --pid-file=/var/run/mariadb/mariadb.pid --socket=/var/lib/mysql/mysql.sock

```

3. 简单配置
（1）执行安全配置向导命令：mysql_secure_installation
```
[root@localhost ~]# mysql_secure_installation 

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] Y
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!


By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] Y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] n
 ... skipping.

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] n
 ... skipping.

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] Y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!

```

（2）登录测试: mysql -uroot -p密码（注意-p和密码之间没有空格）
```
[root@localhost ~]# mysql -uroot -proot123.
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 11
Server version: 5.5.68-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

```

（3）修改字符集

修改/etc/my.cnf文件，在[mysqld]标签下添加：
```
init_connect='SET collation_connection = utf8_unicode_ci'
init_connect='SET NAMES utf8'
character-set-server=utf8
collation-server=utf8_unicode_ci
skip-character-set-client-handshake
```

修改/etc/my.cnf.d/client.cnf文件，在[client]中添加
```
default-character-set=utf8
```

修改/etc/my.cnf.d/mysql-clients.cnf文件，在[mysql]中添加
```
default-character-set=utf8
```

重启mariadb
```
systemctl restart mariadb
```

4. 常用命令
（1）查看有哪些数据库
```
MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
+--------------------+
4 rows in set (0.00 sec)
```
(2) 进入指定数据库，同时查看有哪些表
```
MariaDB [(none)]> use test;
Database changed
MariaDB [test]> show tables;
Empty set (0.00 sec)

```
（3）创建表

5. 安装图形管理工具Navicat Premium
（1）关闭selinux
```
[root@localhost ~]# getenforce 
Enforcing
[root@localhost ~]# setenforce 0
[root@localhost ~]# getenforce 
Permissive
```
（2）关闭firewalld
```
[root@localhost ~]# systemctl stop firewalld
[root@localhost ~]# systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
   Active: inactive (dead) since Sun 2022-03-20 02:45:47 CST; 4min 25s ago
     Docs: man:firewalld(1)
  Process: 5666 ExecStart=/usr/sbin/firewalld --nofork --nopid $FIREWALLD_ARGS (code=exited, status=0/SUCCESS)
 Main PID: 5666 (code=exited, status=0/SUCCESS)

Mar 04 14:57:05 localhost.localdomain systemd[1]: Starting firewalld - dynamic firewall daemon...
Mar 04 14:57:07 localhost.localdomain systemd[1]: Started firewalld - dynamic firewall daemon.
Mar 20 02:45:46 localhost.localdomain systemd[1]: Stopping firewalld - dynamic firewall daemon...
Mar 20 02:45:47 localhost.localdomain systemd[1]: Stopped firewalld - dynamic firewall daemon.
```

(3) 赋予root远程登录权限
查看当前情况，root只能通过127.0.0.1访问
```
MariaDB [test]> select user,host from mysql.user;
+------+-----------------------+
| user | host                  |
+------+-----------------------+
| root | 127.0.0.1             |
| root | ::1                   |
| root | localhost             |
| root | localhost.localdomain |
+------+-----------------------+
4 rows in set (0.00 sec)
```

赋予权限格式：grant 权限 on 数据库对象 to 用户@IP(或者相应正则)
这里赋予root用户数据库所有表（*.*表示所有表），%表示所有IP地址所有权限
```
MariaDB [test]> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root123.' WITH GRANT OPTION;
```

刷新权限
```
MariaDB [test]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)FLUSH PRIVILEGES;
MariaDB [test]> select user,host from mysql.user;
+------+-----------------------+
| user | host                  |
+------+-----------------------+
| root | %                     |
| root | 127.0.0.1             |
| root | ::1                   |
| root | localhost             |
| root | localhost.localdomain |
+------+-----------------------+
5 rows in set (0.00 sec)
```

   