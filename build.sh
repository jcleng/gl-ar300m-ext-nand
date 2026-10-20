#!/bin/bash
# 从头构建
# 本地复刻 .github/workflows/build-openwrt.yml (main / GL-AR300M-NAND) 的构建流程
# ImmortalWrt v25.12.2 -> GL.iNet GL-AR300M (NAND)
#
# 用法:
#   cd /root/wrt && bash build.sh            # 完整构建
#   STEP=download bash build.sh              # 只做到 make download
#
set -e

# OpenWrt 允许 root 构建,但 autoconf 之类的 configure 会拒绝 root,统一绕过
export FORCE_UNSAFE_CONFIGURE=1
export TZ=Asia/Shanghai
# Go 模块走国内代理（proxy.golang.org 在本机不可达）
export GOPROXY="https://goproxy.cn,direct"
export GOSUMDB=off

WORKDIR=/root/wrt
SOURCE_URL=https://github.com/immortalwrt/immortalwrt
SOURCE_BRANCH=v25.12.2
EASYTIER_TAG=v2.6.4

cd "$WORKDIR"

# 0. 拉取上游源码(若不存在)
if [ ! -d openwrt/.git ]; then
  git clone -b "$SOURCE_BRANCH" --single-branch --depth=1 "$SOURCE_URL" openwrt
fi
cd openwrt
echo "SOURCE_REV=$(git rev-parse --short HEAD)"

# 1. 添加 easytier(上游未收录,需手动放入 package/)
if [ ! -d "$WORKDIR/easytier-src" ]; then
  cd "$WORKDIR"
  git clone -b "$EASYTIER_TAG" --depth=1 https://github.com/EasyTier/luci-app-easytier easytier-src
  cd openwrt
fi
cp -f  "$WORKDIR/easytier-src/version.mk" package/version.mk
rm -rf package/easytier package/luci-app-easytier
cp -ar "$WORKDIR/easytier-src/easytier"          package/
cp -ar "$WORKDIR/easytier-src/luci-app-easytier" package/

# 2. feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 3. 载入 .config 并补全
cp "$WORKDIR/gl-ar300m-ext-nand/.config" .config
rm -rf ./bin ./build_dir ./tmp ./staging_dir
make defconfig
grep -E '^CONFIG_TARGET_(BOARD|SUBTARGET|PROFILE)' .config || true

# 4. LAN 192.168.1.1 -> 192.168.8.1
sed -i "s/192\.168\.1\.1/192.168.8.1/" package/base-files/files/bin/config_generate

# 5. 覆盖 files/ (wifi-mgmt-guard)
rm -rf ./files
cp -a "$WORKDIR/gl-ar300m-ext-nand/files" ./files
chmod +x files/etc/init.d/* files/etc/uci-defaults/*
sh -n files/etc/init.d/wifi-mgmt-guard
sh -n files/etc/uci-defaults/99-wifi-mgmt-guard

# 6. 下载源码包
make -j"$(nproc)" download V=s

if [ "$STEP" = "download" ]; then
  echo "== 仅下载完成 =="
  exit 0
fi

# 7. 编译
set -o pipefail
make -j"$(( $(nproc) + 1 ))" V=s 2>&1 | tee build.log

echo "== 固件输出 =="
ls -lh bin/targets/*/*/ 2>/dev/null || true
