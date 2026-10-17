#!/usr/bin/env sh

# ==========================================
# 路由器固件上传脚本（GL-AR300M / ImmortalWrt）
# 用法: ./flash_firmware.sh <固件文件>
# ==========================================

ROUTER_IP="192.168.1.1"
ROUTER_URL="http://${ROUTER_IP}/"
PING_TIMEOUT=3
FILENAME="immortalwrt-ath79-nand-glinet_gl-ar300m-nand-squashfs-factory.img"

FILE="$1"

# ========== 1. 参数检查 ==========
if [ -z "$FILE" ]; then
  echo "❌ 用法: $0 <固件文件路径>"
  echo "   示例: $0 immortalwrt.img"
  exit 1
fi

# ========== 2. 文件检查 ==========
if [ ! -f "$FILE" ]; then
  echo "❌ 文件不存在: $FILE"
  exit 1
fi

FILESIZE=$(du -h "$FILE" | cut -f1)
echo "✅ 固件文件: $FILE"
echo "   文件大小: $FILESIZE"

# ========== 3. 网络连通性检查 ==========
echo "🔍 正在检查路由器 $ROUTER_IP 是否在线..."

if command -v ping >/dev/null 2>&1; then
  if ping -c 1 -W "$PING_TIMEOUT" "$ROUTER_IP" >/dev/null 2>&1; then
    echo "✅ 路由器在线"
  else
    echo "❌ 无法 ping 通 $ROUTER_IP"
    echo "   请确认:"
    echo "     1. 网线已连接"
    echo "     2. 电脑 IP 在 192.168.1.x 网段"
    echo "     3. 路由器已开机"
    exit 1
  fi
else
  echo "⚠️  系统无 ping 命令，跳过连通性检查"
fi

# ========== 4. 开始上传 ==========
echo "🚀 开始上传固件..."
echo "   目标地址: $ROUTER_URL"
echo "   强制文件名: $FILENAME"
echo "   ⚠️  上传过程中请勿断电、断网！"
echo "---------------------------------------------"

curl "$ROUTER_URL" \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
  -H 'Accept-Language: zh-CN,zh;q=0.9' \
  -H 'Origin: http://192.168.1.1' \
  -H 'Referer: http://192.168.1.1/' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36' \
  -F "gl_firmware=@${FILE};filename=${FILENAME};type=application/vnd.efi.img" \
  --insecure \
  --connect-timeout 30 \
  --max-time 300 \
  --fail \
  --progress-bar \
  -w "\n\n📊 HTTP 状态码: %{http_code}\n"

CURL_EXIT=$?

echo "---------------------------------------------"

# ========== 5. 结果判断 ==========
if [ $CURL_EXIT -eq 0 ]; then
  echo "✅ 固件上传成功！"
  echo ""
  echo "📌 后续操作建议："
  echo "   1. 等待路由器自动重启（约 1-3 分钟）"
  echo "   2. 不要手动断电"
  echo "   3. 重启后重新 ping 192.168.1.1"
  echo "   4. 若刷入 ImmortalWrt，首次启动可能较慢"
else
  echo "❌ 上传失败！curl 退出码: $CURL_EXIT"
  echo ""
  case $CURL_EXIT in
    7)  echo "   原因: 无法连接到路由器" ;;
    22) echo "   原因: HTTP 错误（可能固件格式不对或需要认证）" ;;
    28) echo "   原因: 超时（文件过大或网络不稳定）" ;;
    52) echo "   原因: 服务器无返回（路由器可能在重启）" ;;
    *)  echo "   原因: 请查看上方 curl 输出" ;;
  esac
  exit $CURL_EXIT
fi