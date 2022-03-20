

# ZStack环境安装及一些问题解决



## 安装ZStack系统

### 下载iso安装文件

（1）去[zstack产品官网](https://www.zstack.io/product/product_downloads/)下载zstack的iso安装文件**ZStack-Cloud-x86_64-DVD-4.1.3-c76.iso**（zstack4.x版本对UI做了重构，很nice，推荐下载）。

（2）在vmware EXSI服务器上创建一个虚拟机安装，配置4CPU，8GB内存，系统盘64G，数据盘64G（用于存储），两个网卡（一个作为管理口，一个用于创建网络）。另外，CPU配置需要开启硬件虚拟化，这样才能让该节点支持KVM。

（3）安装成功后，访问界面：http://192.168.1.106:5000/，用户是admin，密码是password。

（4）数据盘挂载配置写入/etc/fstab，避免系统重启后，找不到数据。

```
#
# /etc/fstab
# Created by anaconda on Sat Apr 10 02:48:27 2021
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/zstack-root /                       xfs     defaults        0 0
UUID=647f9505-3892-4291-8a92-8242268187d3 /boot                   xfs     defaults        0 0
/dev/mapper/zstack-swap swap                    swap    defaults        0 0
/dev/sdb /vmstore                       ext3     defaults        0 0
```



## 一些问题解决

### 问题一：创建云主机成功，但启动后访问不了控制台

#### 问题介绍

创建云主机成功，但是访问不了控制台，命令行访问卡主，界面访问黑屏。

#### 解决方法

原因是主板兼容问题，virsh edit修改虚拟机xml部分配置，把machine指定的版本改成较低版本（原先是pc-i440fx-rhel7.6.0）。

```xml
  <os>
    <type arch='x86_64' machine='pc-i440fx-rhel7.2.0'>hvm</type>
    <bootmenu enable='yes'/>
    <smbios mode='sysinfo'/>
  </os>
```

> 参考资料：
>
> https://www.virtualizationhowto.com/2019/04/guest-vm-running-in-nested-nutanix-ce-on-vmware-vsphere-wont-boot/



### 问题二：管理IP变更，zstack服务启动失败

#### 问题介绍

zstack环境网口使用的是dhcp地址，系统重启后ip地址变了（从192.168.1.106变成192.168.1.107），导致zstack服务启动失败（zstack用户访问mysql失败）。

```bash
[root@192-168-1-106 ~]# systemctl status zstack
● zstack.service - zstack Service
   Loaded: loaded (/etc/systemd/system/zstack.service; enabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Sun 2021-07-18 02:01:28 CST; 3h 21min ago
  Process: 20834 ExecStart=/usr/bin/zstack-ctl start --daemon (code=exited, status=1/FAILURE)

Jul 18 02:01:28 192-168-1-106 systemd[1]: Starting zstack Service...
Jul 18 02:01:28 192-168-1-106 zstack-ctl[20834]: Starting ZStack management node, it may take a few minutes...
Jul 18 02:01:28 192-168-1-106 zstack-ctl[20834]: ERROR: connect MySQL server[hostname:192.168.1.106, port:3306, user:zstack]: ERROR 2003 (HY000): Can't connect to MySQL server on '192.168.1.106' (111)
Jul 18 02:01:28 192-168-1-106 zstack-ctl[20834]: 
Jul 18 02:01:28 192-168-1-106 systemd[1]: zstack.service: control process exited, code=exited status=1
Jul 18 02:01:28 192-168-1-106 systemd[1]: Failed to start zstack Service.
Jul 18 02:01:28 192-168-1-106 systemd[1]: Unit zstack.service entered failed state.
Jul 18 02:01:28 192-168-1-106 systemd[1]: zstack.service failed.
```

#### 解决方法

（1）修改zstack.properties配置

修改zstack.properties中的ip地址到新地址，然后重启zstack服务。

```bash
[root@192-168-1-107 ~]# sed -i 's/192.168.1.106/192.168.1.107/g' /usr/local/zstack/apache-tomcat/webapps/zstack/WEB-INF/classes/zstack.properties
[root@192-168-1-107 ~]# systemctl restart zstack
```

> zstack.properties是ZStack的核心配置文件。它会存放在每一个管理节点中。 zstack.properties文件中会存放诸如数据库URL，用于数据库访问用户名密码，RabbitmMQ的IP地址等等。 每一个管理节点上的zstack.properties文件的内容基本上是一致的。它的路径可以通过zstack-ctl status来获得。 如果是默认安装的话，它会存放在/usr/local/zstack/apache-tomcat/webapps/zstack/WEB-INF/classes/zstack.properties 。 你可以手动编辑它，也可以通过zstack-ctl configure来完成配置。不过通常情况下， 当用户在使用zstack-ctl命令来安装或者部署对应的服务的时候，zstack-ctl`会自动的完成部署。
> ————————————————
> 原文链接：https://blog.csdn.net/weixin_29798981/article/details/114010539

> 试过修改/etc/hosts文件和hostname是不起作用的，猜测系统启动时，zstact服务是从zstack.properties读配置然后启动其他服务的。

（2）修改mysql数据库表

根据实际情况，可能还要修改其他mysql表，例如：使用的存储是通过网络访问的。

```mysql
修改mysql表中的host字段值，把原域名192-168-1-106改成新域名192-168-1-107，把原IP 192.168.1.106改成新IP 192.168.1.107。
​```
[root@192-168-1-107 ~]# mysql -uroot -pzstack.mysql.password
MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| test               |
| zstack             |
| zstack_rest        |
| zstack_ui          |
+--------------------+
7 rows in set (0.03 sec)

MariaDB [zstack]> use mysql;
MariaDB [mysql]> select host,user,password from user;
+---------------+-----------+-------------------------------------------+
| host          | user      | password                                  |
+---------------+-----------+-------------------------------------------+
| localhost     | root      | *00F7D29C5D499ED55880D59900110123CDC8F66A |
| 192-168-1-106 | root      | *00F7D29C5D499ED55880D59900110123CDC8F66A |
| 127.0.0.1     | root      | *00F7D29C5D499ED55880D59900110123CDC8F66A |
| ::1           | root      |                                           |
| localhost     |           |                                           |
| 192-168-1-106 |           |                                           |
| 192.168.1.106 | root      | *00F7D29C5D499ED55880D59900110123CDC8F66A |
| %             | root      | *00F7D29C5D499ED55880D59900110123CDC8F66A |
| localhost     | zstack    | *0EE5DC1F2BF5512284EDB05976CDD8BE4CFBD348 |
| %             | zstack    | *0EE5DC1F2BF5512284EDB05976CDD8BE4CFBD348 |
| 192-168-1-106 | zstack    | *0EE5DC1F2BF5512284EDB05976CDD8BE4CFBD348 |
| localhost     | zstack_ui | *B30528EDF6C1CB6896B71ABAEB56664E9AA4D228 |
| %             | zstack_ui | *B30528EDF6C1CB6896B71ABAEB56664E9AA4D228 |
| 192-168-1-106 | zstack_ui | *B30528EDF6C1CB6896B71ABAEB56664E9AA4D228 |
+---------------+-----------+-------------------------------------------+
14 rows in set (0.00 sec)

MariaDB [mysql]> UPDATE user SET host='192-168-1-107' WHERE host='192-168-1-106';
Query OK, 4 rows affected (0.00 sec)
Rows matched: 4  Changed: 4  Warnings: 0

MariaDB [mysql]> UPDATE user SET host='192.168.1.107' WHERE host='192.168.1.106';
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```

（3）修改后发现还是报错（zstack_ui用户访问mysql失败）

```
[root@192-168-1-107 ~]# systemctl status zstack -l
● zstack.service - zstack Service
   Loaded: loaded (/etc/systemd/system/zstack.service; enabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Sun 2021-07-18 11:16:14 CST; 1h 4min ago

Jul 18 11:16:10 192-168-1-107 ansible-pip[4847]: Invoked with virtualenv=/var/lib/zstack/virtualenv/consoleproxy/ extra_args=--disable-pip-version-check --trusted-host 192.168.1.107 -i http://192.168.1.107:8080/zstack/static/pypi/simple -U  virtualenv_command=virtualenv chdir=None requirements=None name=/var/lib/zstack/console/package/consoleproxy-4.0.0.tar.gz executable=None use_mirrors=True virtualenv_site_packages=False state=present version=None
Jul 18 11:16:11 192-168-1-107 zstack-ctl[31736]: ERROR: connect MySQL server[hostname:192.168.1.106, port:3306, user:zstack_ui]: ERROR 2003 (HY000): Can't connect to MySQL server on '192.168.1.106' (113)
Jul 18 11:16:11 192-168-1-107 systemd[1]: zstack.service: control process exited, code=exited status=1
Jul 18 11:16:11 192-168-1-107 zstack-ctl[31736]: 
Jul 18 11:16:11 192-168-1-107 sudo[4871]:   zstack : PWD=/usr/local/zstack ; USER=root ; COMMAND=/usr/bin/pgrep -f mysqld.*datadir
Jul 18 11:16:12 192-168-1-107 sudo[4885]:   zstack : PWD=/usr/local/zstack ; USER=root ; COMMAND=/usr/bin/systemctl stop influxdb-server
Jul 18 11:16:12 192-168-1-107 sudo[4893]:   zstack : PWD=/usr/local/zstack ; USER=root ; COMMAND=/usr/bin/pgrep -f mysqld.*datadir
Jul 18 11:16:14 192-168-1-107 systemd[1]: Failed to start zstack Service.
Jul 18 11:16:14 192-168-1-107 systemd[1]: Unit zstack.service entered failed state.
Jul 18 11:16:14 192-168-1-107 systemd[1]: zstack.service failed.

```

> TODO: https://blog.51cto.com/zhaijunming5/1703123
>
> https://blog.csdn.net/weixin_39765339/article/details/114010540
>
> 你好，我在vmware exsi服务器上，用zstack的iso安装了个虚拟机，网口使用的地址是dhcp的。系统重启后，那个ip变了，导致zstack服务启动失败，应该修改什么恢复呢。最开始报错是，zstack-ctl[20834]: ERROR: connect MySQL server[hostname:192.168.1.106, port:3306, user:zstack]:，然后把zstack.properties配置文件里的ip已经更新好了，重启zstack服务。但是启动后报错，zstack-ctl[31736]: ERROR: connect MySQL server[hostname:192.168.1.106, port:3306, user:zstack_ui]:，看着是zstack_ui这个用户连接mysql用的配置没更行，这个不知道应该改哪了。

（3）修改zstack.ui.properties

```bash
[root@192-168-1-106 ~]# sed -i 's/192.168.1.106/192.168.1.107/g' /usr/local/zstack/zstack-ui/zstack.ui.properties 
[root@192-168-1-107 ~]# systemctl restart zstack
```

（4）重启zstack系统

前面的操作都完成了，登zstack页面还是访问不了，自动重定向到了http://192.168.1.107:5000/?login/redirect

重启zstacck系统，等zstack服务状态变成running状态后，就可以访问界面了。

（5）重连物理机

zstack扩展计算节点是通过添加物理机完成的，所以物理机的IP也需要更新，更新之后执行重连操作，一切就都正常了。

