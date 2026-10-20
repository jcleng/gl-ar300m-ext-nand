#!/bin/bash
# 二次构建
# 独立运行的固件构建脚本（用 setsid 脱离会话，避免被回收）
export FORCE_UNSAFE_CONFIGURE=1
export TZ=Asia/Shanghai
# Go 模块走国内代理（proxy.golang.org 在本机不可达）
export GOPROXY="https://goproxy.cn,direct"
export GOSUMDB=off
cd /root/wrt/openwrt || exit 1

echo "=== START $(date) ==="
make -j"$(nproc)" download V=s
echo "DOWNLOAD_EXIT=$?"
make -j"$(( $(nproc) + 1 ))" V=s
echo "BUILD_EXIT=$?"
echo "=== 产物 ==="
ls -lh bin/targets/*/*/ 2>/dev/null
echo "=== END $(date) ==="
