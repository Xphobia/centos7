# OpenSSH rpm包制作及测试

| 版本 | 作者    | 更新         | 时间       |
| ---- | ------- | ------------ | ---------- |
| 1.0  | Xphobia | openssh8.5p1 | 2021/06/24 |
|      |         |              |            |
|      |         |              |            |



## 1、准备工作

### 工作环境

CentOS Linux release 7.6.1810

### 安装打包工具

```bash
yum install -y rpm-build rpmdevtools wget
```

（optional）安装其他辅助工具

```bash
yum install -y tree
```

### 配置代理

如果处于内网环境无法访问互联网，就需要在PC端配置代理，并在服务器shell导出类似代理配置如下：

```bash
export https_proxy=https://192.168.1.100:8888
```



## 2、制作过程

### 初始化工作目录

在/root目录下，执行rpmdev-setuptree命令，生成rpmbuild目录，rpm包制作过程将在该目录中完成。。

```bash
rpmdev-setuptree
```

可以执行tree rpmbuild查看其目录结构。

```bash
[root@00-b3-42-02-b1-28 ~]# tree rpmbuild/
rpmbuild/
|-- BUILD
|-- RPMS
|-- SOURCES
|-- SPECS
`-- SRPMS

5 directories, 0 files
```

### 下载源码包

下载openssh8.5p1源码包

```bash
wget -P /root/rpmbuild/SOURCES https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.5p1.tar.gz 
```

下载x11-ssh-askpass-1.2.4.1源码包

```bash
wget -P /root/rpmbuild/SOURCES https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz 
```

### 修改spec文件

解压openssh源码包

```bash
tar xzf /root/rpmbuild/SOURCES/openssh-8.5p1.tar.gz -C /tmp
```

复制openssh.spec文件到/root/rpmbuild/SPECS目录

```bash
cp /tmp/openssh-8.5p1/contrib/redhat/openssh.spec /root/rpmbuild/SPECS
```

删除解压出的源码目录

```bash
rm -rf /tmp/openssh-8.5p1
```

修改openssh.spec配置

```bash
vi /root/rpmbuild/SPECS/openssh.spec
```

注释掉BuildRequires: openssl-devel < 1.1，因为目前安装的版本都低于1.1

```bash
# BuildRequires: openssl-devel >= 1.0.1
# BuildRequires: openssl-devel < 1.1
```

关于askpass的配置修改如下

```bash
%global no_x11_askpass 1
%global no_gnome_askpass 1
```

### 安装编译依赖包

配置yum源

如果是x86平台

```
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
```

如果是aarch64平台

```
wget http://mirrors.aliyun.com/repo/Centos-altarch-7.repo -O /etc/yum.repos.d/CentOS-Base.repo
```

安装编译openssh需要的库

```bash
yum install -y gcc glibc-devel krb5-devel zlib-devel openssl-devel pam-devel 
```

### 制作rpm包

在/root 目录中执行

```bash
rpmbuild -ba /root/rpmbuild/SPECS/openssh.spec
```

做好的rpm包在/root/rpmubild/RPMS/x86_64/目录

```bash
[root@00-b3-42-02-b1-28 SPECS]# tree ../RPMS/x86_64/
../RPMS/x86_64/
|-- openssh-8.4p1-1.el7.centos.x86_64.rpm
|-- openssh-clients-8.4p1-1.el7.centos.x86_64.rpm
|-- openssh-debuginfo-8.4p1-1.el7.centos.x86_64.rpm
`-- openssh-server-8.4p1-1.el7.centos.x86_64.rpm

0 directories, 4 files
```



## 3、升级测试

## 编写openssh升级脚本



### SSH客户端远程连接测试

测试工具主要有：Xshell、SSHSecureShellClient



## 参考资料

[openssh 8.0 rpm 制作](https://www.cnblogs.com/liweiming/p/11571841.html)

