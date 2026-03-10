#!/bin/bash
set -e

# Claw Cooking 数据备份脚本
echo "🦞 开始备份 Claw Cooking 数据..."
echo "=========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 变量定义
BACKUP_DIR="${BACKUP_DIR:-${HOME}/.openclaw/backup/clawcook}"
BACKUP_DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/clawcook_backup_${BACKUP_DATE}.tar.gz"
RETENTION_COUNT=${RETENTION_COUNT:-7}

# 要备份的内容
BACKUP_ITEMS=(
    "${HOME}/.openclaw/config"
    "${HOME}/.openclaw/workspace"
    "${HOME}/.openclaw/memory"
    "${HOME}/.openclaw/sessions"
    "${HOME}/.openclaw/agents"
    "${HOME}/.openclaw/skills"
)

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 函数：检查目录是否存在
check_dir() {
    local dir=$1
    if [ -d "$dir" ]; then
        return 0
    else
        echo -e "⚠️  ${YELLOW}目录 ${dir} 不存在，跳过${NC}"
        return 1
    fi
}

# 收集要备份的目录
echo -e "\n📦 收集要备份的内容..."
BACKUP_PATHS=()
for item in "${BACKUP_ITEMS[@]}"; do
    if check_dir "$item"; then
        BACKUP_PATHS+=("$item")
    fi
done

if [ ${#BACKUP_PATHS[@]} -eq 0 ]; then
    echo -e "❌ ${RED}没有需要备份的内容${NC}"
    exit 1
fi

# 执行备份
echo -e "\n🔄 正在创建备份文件..."
echo "备份文件: ${BACKUP_FILE}"

if tar -czf "$BACKUP_FILE" "${BACKUP_PATHS[@]}"; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')
    echo -e "✅ ${GREEN}备份完成！大小: ${BACKUP_SIZE}${NC}"
else
    echo -e "❌ ${RED}备份失败${NC}"
    exit 1
fi

# 清理旧备份
echo -e "\n🧹 清理旧备份（保留最近 ${RETENTION_COUNT} 份）..."
old_backups=$(ls -t "${BACKUP_DIR}/clawcook_backup_"*.tar.gz 2>/dev/null | tail -n +$((RETENTION_COUNT + 1)))
if [ -n "$old_backups" ]; then
    echo "删除旧备份:"
    echo "$old_backups" | while read -r file; do
        rm -f "$file"
        echo "  - $(basename "$file")"
    done
else
    echo "✅ 没有需要清理的旧备份"
fi

# 备份完成
echo -e "\n🎉 ${GREEN}数据备份完成！${NC}"
echo "=========================================="
echo ""
echo "📝 备份信息："
echo "备份文件: ${BACKUP_FILE}"
echo "备份大小: ${BACKUP_SIZE}"
echo "备份时间: ${BACKUP_DATE}"
echo ""
echo "💡 恢复方法："
echo "1. 停止服务: openclaw gateway stop"
echo "2. 解压备份: tar -xzf ${BACKUP_FILE} -C /"
echo "3. 启动服务: openclaw gateway start"
