

查看当前openssl版本

```
[root@localhost ~]# rpm -qa | grep openssl
openssl-libs-1.0.1e-60.el7.x86_64
openssl-1.0.1e-60.el7.x86_64
[root@localhost ~]# 
[root@localhost ~]# openssl version
OpenSSL 1.0.1e-fips 11 Feb 2013
```

查看openssl-libs安装目录

```
[root@localhost ~]# rpm -ql openssl-libs
/etc/pki/tls
/etc/pki/tls/certs
/etc/pki/tls/misc
/etc/pki/tls/openssl.cnf
/etc/pki/tls/private
/usr/lib64/.libcrypto.so.1.0.1e.hmac
/usr/lib64/.libcrypto.so.10.hmac
/usr/lib64/.libssl.so.1.0.1e.hmac
/usr/lib64/.libssl.so.10.hmac
/usr/lib64/libcrypto.so.1.0.1e
/usr/lib64/libcrypto.so.10
/usr/lib64/libssl.so.1.0.1e
/usr/lib64/libssl.so.10
/usr/lib64/openssl
/usr/lib64/openssl/engines
/usr/lib64/openssl/engines/lib4758cca.so
/usr/lib64/openssl/engines/libaep.so
/usr/lib64/openssl/engines/libatalla.so
/usr/lib64/openssl/engines/libcapi.so
/usr/lib64/openssl/engines/libchil.so
/usr/lib64/openssl/engines/libcswift.so
/usr/lib64/openssl/engines/libgmp.so
/usr/lib64/openssl/engines/libnuron.so
/usr/lib64/openssl/engines/libpadlock.so
/usr/lib64/openssl/engines/libsureware.so
/usr/lib64/openssl/engines/libubsec.so
/usr/share/doc/openssl-libs-1.0.1e
/usr/share/doc/openssl-libs-1.0.1e/LICENSE
```





清除旧版本openssl

```
rpm -e --nodeps openssl
```

```
[root@localhost ~]# rpm -e --nodeps openssl
[root@localhost ~]# rpm -qa | grep openssl
openssl-libs-1.0.1e-60.el7.x86_64
```

```
openssl-libs保留，不需要移除，否则系统可能会坏掉。
```



安装新版本openssl

```
rpm -ivh --nodeps openssl-1.1.0l-1.el7.centos.x86_64
```

```
[root@localhost ~]# rpm -ivh --nodeps --force openssl-1.1.0l-1.el7.centos.x86_64
Preparing...                          ################################# [100%]
Updating / installing...
   1:openssl-1.1.0l-1.el7.centos      ################################# [100%]
```

查看新版本openssl安装目录

```
[root@localhost ~]# ls /usr/local/openssl/
bin  certs  include  lib  misc  openssl.cnf  openssl.cnf.dist  private  share
```



