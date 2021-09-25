# 定制centos7的vmdk镜像



## 下载镜像

### 下载

```bash
[root@localhost ~]# curl -LO https://sourceforge.net/projects/osboxes/files/v/vm/10-Cn-t/7/7-18.10/18-1064.7z/download
```

下载网站：https://www.osboxes.org/centos/#centos-7-1810-vmware

下载地址：https://sourceforge.net/projects/osboxes/files/v/vm/10-Cn-t/7/7-18.10/18-1064.7z/download

### 解压

安装解压工具

```bash
[root@localhost ~]# yum install -y epel-release
[root@localhost ~]# yum install -y p7zip p7zip-plugins
```

解压镜像包

```bash
[root@localhost ~]# 7za x 18-1064.7z
[root@localhost ~]# ll -h  64bit/
total 4.6G
-rwx------. 1 root root 4.6G Feb 12  2019 CentOS 7-18.10 (64bit).vmdk
```

