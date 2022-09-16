


1、下载mysql的.src.rpm包

下载地址：https://downloads.mysql.com/archives/community/

![image](https://user-images.githubusercontent.com/59901623/190537377-cbdf4cf7-6bc2-496e-b520-29b24ac3a82b.png)

2、上传mysql-community-5.7.38-1.el7.src.rpm，安装

```
[root@localhost ~]# rpm -ivh mysql-community-5.7.38-1.el7.src.rpm 
warning: mysql-community-5.7.38-1.el7.src.rpm: Header V4 RSA/SHA256 Signature, key ID 3a79bd29: NOKEY
Updating / installing...
   1:mysql-community-5.7.38-1.el7     ################################# [100%]
warning: user pb2user does not exist - using root
warning: group common does not exist - using root
warning: user pb2user does not exist - using root
warning: group common does not exist - using root
warning: user pb2user does not exist - using root
warning: group common does not exist - using root
warning: user pb2user does not exist - using root
warning: group common does not exist - using root
warning: user pb2user does not exist - using root
warning: group common does not exist - using root
warning: user pb2user does not exist - using root
warning: group common does not exist - using root
[root@localhost ~]# tree rpmbuild
rpmbuild
├── SOURCES
│   ├── boost_1_59_0.tar.bz2
│   ├── filter-provides.sh
│   ├── filter-requires.sh
│   ├── mysql-5.6.51.tar.gz
│   └── mysql-5.7.38.tar.gz
└── SPECS
    └── mysql.spec

2 directories, 6 files
```

3、rpmbuild打包

```
[root@localhost ~]# rpmbuild -ba /root/rpmbuild/SPECS/mysql.spec
```
可能缺少依赖，缺什么安装就是了
```
 yum install cmake
 yum install -y perl-Env perl-JSON
 yum install -y libaio-devel ncurses-devel numactl-devel openssl-devel zlib-devel cyrus-sasl-devel openldap-devel
```

4、打包结束，生成的rpm包在/root/rpmbuild/RPMS目录
```
[root@localhost ~]# tree rpmbuild-mysql-community-5.7.38/RPMS/
rpmbuild-mysql-community-5.7.38/RPMS/
└── x86_64
    ├── mysql-community-client-5.7.38-1.el7.x86_64.rpm
    ├── mysql-community-common-5.7.38-1.el7.x86_64.rpm
    ├── mysql-community-devel-5.7.38-1.el7.x86_64.rpm
    ├── mysql-community-embedded-5.7.38-1.el7.x86_64.rpm
    ├── mysql-community-embedded-compat-5.7.38-1.el7.x86_64.rpm
    ├── mysql-community-embedded-devel-5.7.38-1.el7.x86_64.rpm
    ├── mysql-community-libs-5.7.38-1.el7.x86_64.rpm
    ├── mysql-community-libs-compat-5.7.38-1.el7.x86_64.rpm
    ├── mysql-community-server-5.7.38-1.el7.x86_64.rpm
    └── mysql-community-test-5.7.38-1.el7.x86_64.rpm

1 directory, 10 files
```

|                         包名      |                   功能            |
| --------------------------------- | ----------------------------- |
| mysql-community-client            | 提供MySQL数据库客户端应用程序和工具          |
| mysql-community-common            | 提供MySQL数据库和客户端库共享文件 （工具）      |
| mysql-community-devel             | 提供MySQL数据库客户端应用程序的库和头文件       |
| mysql-community-embedded          | MySQL嵌入式函数库                   |
| mysql-community-embedded-compat   | MySQL嵌入式兼容函数库                 |
| mysql-community-embedded-devel    | 头文件和库文件作为Mysql的嵌入式库文件         |
| mysql-community-libs              | MySQL 数据库客户端应用程序的共享库          |
| mysql-community-libs-compat       | MySQL 5.6.31 数据库客户端应用程序的共享兼容库 |
| mysql-community-minimal-debuginfo | mysql最小安装包的调试信息               |
| mysql-community-server            | 非常快速和可靠的 SQL 数据库服务器           |
| mysql-community-server-minimal    | 非常快速和可靠的 SQL 数据库服务器(最小化安装)    |
| mysql-community-test              |                               |

必须要有的两个包：

　　mysql-community-client :提供工具  

　　mysql-community-server: 提供服务的包
