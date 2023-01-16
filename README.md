
# gl-ar300m-nand 编译

- [openwrt wiki howto build](https://openwrt.org/zh-cn/doc/howto/build)

- 配置

  ![https://z3.ax1x.com/2021/05/29/2AGStf.png](https://z3.ax1x.com/2021/05/29/2AGStf.png)


- 如何生成自己的.config配置文件

```shell
# 使用 http://kgithub.com/noonien/docker-openwrt-buildroot 的docker镜像进行配置(下载feeds插件要一致),然后运行进行配置TUI界面

# 保存之后用scripts/diffconfig.sh脚本进行导出刚刚配置的文件
./scripts/diffconfig.sh > min.config
# 然后把min.config内容替换到本项目的.config文件即可(项目编译的时候make defconfig会重新补全的)
```

- 扩展软件包(插件)

```shell
# 除了源自带的immortalwrt/packages外,可用手动添加其他的软件
# kenzok8/openwrt-packages
https://github.com/kenzok8/openwrt-packages
```

- 下载官方的uboot-img镜像(使用nand,nor不去动)

  openwrt官方[下载](https://downloads.openwrt.org/releases/22.03.3/targets/ath79/nand/)

  gl官方[下载](https://docs.gl-inet.com/en/3/release_notes/gl-ar300m/)

  [immortalwrt构建](https://downloads.immortalwrt.org/releases/21.02.3/targets/ath79/nand/)
