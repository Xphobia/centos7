


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

