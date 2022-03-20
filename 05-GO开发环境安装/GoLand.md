

## GoLand安装与激活

## 下载安装GoLand

官网[GoLand下载](https://www.jetbrains.com/go/)windows平台的版本，这里以GoLand 2021.1.3版本为例。下载后安装，这里以安装目录E:\Software\GoLand 2021.1.3为例。

### 激活GoLand

打开GoLand选择Evaluate for free版本，把自动激活插件<b>ide-eval-resetter-2.1.6.zip</b>拖到GoLand IDE中，插件会自动安装，安装成功后重启GoLand，每次重启GoLand会自动重新激活，相当于永久激活了。



## GO开发环境设置

### 设置GOROOT

GOROOT是GO安装的路径：

```
File -> Settings -> GOROOT -> E:\Software\GoLand 2021.1.3\go1.16.5
```

### 启用GO Modules

官方声明，GO Modules在1.14版本可以适用于生产环境。

```
File -> Settings -> Go Modules -> Enable Go Modules integration (勾选)
```

设置Environment值

```
GOPROXY=https://mirrors.aliyun.com/goproxy/,direct;GO111MODULE=on
```

### 禁用GOPATH

使用GO Modules管理包，需要禁用掉GOPATH设置。

```
File -> Settings -> GOPATH -> 删除所有GOPATH设置 -> 取消勾选所有GOPATH设置
```



## GoLand IDE常用设置

### 打开工具栏

```
View -> Appearance -> Toolbar (勾选)
```



### 关闭单词拼写错误检查

```
File -> Settings -> Editor -> Inspections -> Proofreading -> Typo (取消勾选)
```

### 关闭参数提示

```
File -> Settings -> Editor -> Inlay Hints -> Go -> Parameter hints -> Show parameter hints (取消勾选)
```



## GoLand常用插件

```
File -> Settings -> Plugins -> 搜索插件名下载
```

| 插件名称 | 插件功能 | 说明               |
| -------- | -------- | ------------------ |
| IdeaVim  | vim      | 相当于Linux下的Vim |
|          |          |                    |
|          |          |                    |

