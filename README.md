
# gl-ar300m-nand 编译

配置
![https://z3.ax1x.com/2021/05/29/2AGStf.png](https://z3.ax1x.com/2021/05/29/2AGStf.png)


![https://z3.ax1x.com/2021/05/29/2A08DU.png](https://z3.ax1x.com/2021/05/29/2A08DU.png)


下载当前固件： actions里面最新即可 https://github.com/jcleng/gl-ar300m-ext-nand/actions/runs/888316599

- 下载官方的uboot-img镜像(使用nand,nor不去动)

openwrt官方[下载](https://downloads.openwrt.org/releases/21.02.0-rc1/targets/ath79/nand/)

gl官方[下载](https://docs.gl-inet.com/en/3/release_notes/gl-ar300m/)

- 如何生成自己的.config配置文件

```shell
# 使用 http://kgithub.com/noonien/docker-openwrt-buildroot 的docker镜像进行配置(下载feeds插件要一致),然后运行进行配置TUI界面

# 保存之后用scripts/diffconfig.sh脚本进行导出刚刚配置的文件
./scripts/diffconfig.sh > min.config
# 然后把min.config内容替换到本项目的.config文件即可(项目编译的时候make defconfig会重新补全的)
```
