======================
immortalwrt自用构建
======================

`openwrt wiki howto build <https://openwrt.org/zh-cn/doc/howto/build>`_

增加adguard home,openclash,docker支持

设备列表
======================

===============  ===============
型号              分支
===============  ===============
ignet ar300m     main
x86              x86
jcg q30 pro      jcg_q30_pro
===============  ===============

如何生成自己的.config配置文件
==============================

.. code-block:: shell

   # 使用 http://github.com/noonien/docker-openwrt-buildroot 的docker镜像进行配置(下载feeds插件要一致),然后运行进行配置TUI界面

   # 保存之后用scripts/diffconfig.sh脚本进行导出刚刚配置的文件
   ./scripts/diffconfig.sh > min.config
   # 然后把min.config内容替换到本项目的.config文件即可(项目编译的时候make defconfig会重新补全的)

扩展软件包(插件)
==============================

.. code-block:: shell

   # 除了源自带的immortalwrt/packages外,可用手动添加其他的软件
   # kenzok8/openwrt-packages
   https://github.com/kenzok8/openwrt-packages

ar300m使用: 下载官方的uboot-img镜像(使用nand,nor不去动)
==============================

  `openwrt官方下载 <https://downloads.openwrt.org/releases/22.03.3/targets/ath79/nand/>`_

  `gl官方下载 <https://docs.gl-inet.com/en/3/release_notes/gl-ar300m/>`_

  `immortalwrt构建 <https://downloads.immortalwrt.org/releases/21.02.3/targets/ath79/nand/>`_