源码制作rpm包（以qemu为例）

安装编译工具

```
yum install -y autoconf automake libtool gcc
```



 安装rpm包制作工具

```bash
yum install -y rpm-build rpmdevtools rpmrebuild rpm cpio
```

提取rpm包的spec文件

```bash
rpmrebuild -e -p --notest-install <path2package>
```

提取rpm包打包的文件

```bash
rpm2cpio <path2package>| cpio -div
```

查看rpm包里的文件

```bash
rpm -qlp <path2package>
```

查看已安装的rpm包里的文件

```bash
rpm -ql <packagename>
```

查看rpm包的安装前脚本、安装后脚本

```
rpm -qp --scripts <path2package>
```

```
rpm -q --scripts <packagename>
```





安装依赖包

```bash
yum install -y git glib2-devel libfdt-devel pixman-devel zlib-devel
```

```bash
yum install -y libaio-devel libcap-devel libiscsi-devel
```



```
tar jxvf XX.tar.bz2

如果tar不支持j选项，就用下面方式解压

bzip2 -d  XX.tar.bz2

tar -xvf  XX.tar.bz2
```









参考：https://wiki.qemu.org/Hosts/Linux



参考资料:

[Building RPM packages from source - a QEMU example](https://neutrollized.blogspot.com/2018/02/building-rpm-package-from-source-qemu.html)

[RPM 包的构建 - SPEC 基础知识](https://www.cnblogs.com/michael-xiang/p/10480809.html)

[提取原rpm包里的SPEC文件及重新打包](https://blog.csdn.net/jk775800/article/details/88643440)