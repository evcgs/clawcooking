#!/bin/bash
set -e

# Claw Cooking 一键更新脚本
echo "🦞 开始更新 Claw Cooking..."
echo "=========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 变量定义
CLAWCOOK_HOME="${CLAWCOOK_HOME:-$(pwd)}"
BACKUP_FIRST=true
UPDATE_BRANCH="main"

# 参数解析
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --no-backup) BACKUP_FIRST=false ;;
        --branch) UPDATE_BRANCH="$2"; shift ;;
        *) echo "未知参数: $1"; exit 1 ;;
    esac
    shift
done

# 备份数据
if [ "$BACKUP_FIRST" = true ]; then
    echo -e "\n💾 先备份数据..."
    "${CLAWCOOK_HOME}/scripts/backup.sh"
fi

# 拉取最新代码
echo -e "\n📥 拉取最新代码..."
cd "$CLAWCOOK_HOME"
if git pull origin "$UPDATE_BRANCH"; then
    echo -e "✅ ${GREEN}代码更新成功${NC}"
else
    echo -e "❌ ${RED}代码更新失败，请检查Git仓库配置${NC}"
    exit 1
fi

# 更新基础配置
echo -e "\n⚙️  更新基础配置模板..."
cp -n "${CLAWCOOK_HOME}/recipes/base/model.yaml" "${HOME}/.openclaw/config/models.yaml.new"
cp -n "${CLAWCOOK_HOME}/recipes/base/channel.yaml" "${HOME}/.openclaw/config/channels/channel.yaml.new"
cp -n "${CLAWCOOK_HOME}/recipes/base/security.yaml" "${HOME}/.openclaw/config/security.yaml.new"
echo -e "ℹ️  新配置模板已保存为 .new 后缀，请手动合并差异"

# 更新智能体和技能
echo -e "\n🔄 更新智能体和技能..."
openclaw skills update
openclaw agents update

# 重新部署
echo -e "\n🚀 重新部署最新版本..."
"${CLAWCOOK_HOME}/scripts/deploy.sh"

# 重启服务
echo -e "\n🔄 重启服务..."
openclaw gateway restart

# 验证状态
echo -e "\n✅ 验证更新结果..."
sleep 3
if openclaw gateway status | grep -q "running"; then
    echo -e "✅ ${GREEN}服务运行正常${NC}"
else
    echo -e "⚠️  ${YELLOW}服务启动异常，请检查日志${NC}"
fi

# 更新完成
echo -e "\n🎉 ${GREEN}Claw Cooking 更新完成！${NC}"
echo "=========================================="
echo ""
echo "📝 更新说明："
echo "当前版本: $(git rev-parse --short HEAD)"
echo "更新时间: $(date)"
echo ""
echo "💡 注意事项："
echo "1. 请检查 .new 后缀的配置文件，手动合并新增的配置项"
echo "2. 查看 CHANGELOG.md 了解本次更新的内容"
echo "3. 如有问题可以恢复备份：./scripts/backup.sh 目录下有更新前的备份"
