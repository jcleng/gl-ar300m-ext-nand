======================
immortalwrt自用构建
======================

`openwrt wiki howto build <https://openwrt.org/zh-cn/doc/howto/build>`_

增加adguard home,openclash,docker支持

.. image:: https://img1.imgtp.com/2023/10/30/J0d2RD7c.png
  :width: 800px

设备列表
======================

===============  =============== ======================================================================================================================== ===============
型号              分支            构建状态                                                                                                                  推荐下载
===============  =============== ======================================================================================================================== ===============
ignet ar300m     main            .. image:: https://github.com/jcleng/gl-ar300m-ext-nand/workflows/Build%20OpenWrt/badge.svg                              `202311261836 openwrt-23.02 <https://github.com/jcleng/gl-ar300m-ext-nand/releases/tag/OpenWrt_firmware_glinet_gl-ar300m-nand_202311261836>`_ , `202310302054 openwrt-21.02 <https://github.com/jcleng/gl-ar300m-ext-nand/releases/tag/OpenWrt_firmware_glinet_gl-ar300m-nand_202310302054>`_
x86              x86             .. image:: https://github.com/jcleng/gl-ar300m-ext-nand/workflows/Build%20OpenWrt(x86)/badge.svg
jcg q30 pro      jcg_q30_pro     .. image:: https://github.com/jcleng/gl-ar300m-ext-nand/workflows/Build%20OpenWrt%20jcg_q30_pro/badge.svg
===============  =============== ======================================================================================================================== ===============

如何生成自己的.config配置文件
==============================

.. code-block:: shell

   # 使用 registry.cn-hangzhou.aliyuncs.com/jcleng/wrt-ubuntu:20.04 的docker镜像进行配置(下载feeds插件要一致),然后运行进行配置TUI界面(进入容器不要用root用户: docker exec -it -u $(id -u) wrt bash)

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
