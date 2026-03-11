#!/bin/bash
set -e

# Claw Cooking 一键安装脚本
echo "🦞 欢迎使用 Claw Cooking 龙虾烹饪手册安装脚本"
echo "=========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 变量定义
CLAWCOOK_HOME="${CLAWCOOK_HOME:-$(pwd)}"
OPENCLAW_CONFIG_DIR="${HOME}/.openclaw"
CHECK_ONLY=false
OFFLINE=false
DOWNLOAD_ONLY=false

# 参数解析
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --check) CHECK_ONLY=true ;;
        --offline) OFFLINE=true ;;
        --download-only) DOWNLOAD_ONLY=true ;;
        *) echo "未知参数: $1"; exit 1 ;;
    esac
    shift
done

# 检查函数
check_dependency() {
    local cmd=$1
    local name=$2
    if command -v "$cmd" &> /dev/null; then
        echo -e "✅ ${GREEN}${name} 已安装: $(command -v "$cmd")${NC}"
        return 0
    else
        echo -e "❌ ${RED}${name} 未安装${NC}"
        return 1
    fi
}

# 环境检查
echo -e "\n🔍 开始环境检查..."
echo "--------------------------"

# 检查 OpenClaw
if ! check_dependency "openclaw" "OpenClaw"; then
    echo -e "${YELLOW}请先安装 OpenClaw: https://github.com/openclaw/openclaw${NC}"
    exit 1
fi

# 检查 Node.js
if ! check_dependency "node" "Node.js"; then
    echo -e "${YELLOW}请先安装 Node.js v25+: https://nodejs.org/${NC}"
    exit 1
fi

# 检查 Git
if ! check_dependency "git" "Git"; then
    echo -e "${YELLOW}请先安装 Git: https://git-scm.com/${NC}"
    exit 1
fi

# 检查工作目录权限
if [ -w "$OPENCLAW_CONFIG_DIR" ]; then
    echo -e "✅ ${GREEN}工作目录权限正常${NC}"
else
    echo -e "❌ ${RED}工作目录 ${OPENCLAW_CONFIG_DIR} 没有写入权限${NC}"
    exit 1
fi

# 如果只是检查，到此结束
if [ "$CHECK_ONLY" = true ]; then
    echo -e "\n🎉 ${GREEN}环境检查全部通过！${NC}"
    exit 0
fi

# 如果是仅下载模式
if [ "$DOWNLOAD_ONLY" = true ]; then
    echo -e "\n📥 开始下载依赖..."
    echo "--------------------------"
    
    # 下载 OpenClaw 技能和智能体元数据
    openclaw skills update --download-only
    openclaw agents update --download-only
    
    echo -e "\n🎉 ${GREEN}依赖下载完成！可以复制到离线环境使用了${NC}"
    exit 0
fi

# 开始安装
echo -e "\n📦 开始安装 Claw Cooking..."
echo "--------------------------"

# 创建目录结构
echo "📂 创建目录结构..."
mkdir -p "${OPENCLAW_CONFIG_DIR}/skills/custom"
mkdir -p "${OPENCLAW_CONFIG_DIR}/agents/custom"
mkdir -p "${OPENCLAW_CONFIG_DIR}/workspace/memory"
mkdir -p "${OPENCLAW_CONFIG_DIR}/backup/clawcook"
mkdir -p "${OPENCLAW_CONFIG_DIR}/config"
mkdir -p "${OPENCLAW_CONFIG_DIR}/config/channels"

# 复制基础配置
echo "⚙️  复制基础配置模板..."
cp -n "${CLAWCOOK_HOME}/recipes/base/model.yaml" "${OPENCLAW_CONFIG_DIR}/config/models.yaml"
cp -n "${CLAWCOOK_HOME}/recipes/base/channel.yaml" "${OPENCLAW_CONFIG_DIR}/config/channels/"
cp -n "${CLAWCOOK_HOME}/recipes/base/security.yaml" "${OPENCLAW_CONFIG_DIR}/config/security.yaml"
cp -n "${CLAWCOOK_HOME}/recipes/base/agent.yaml" "${OPENCLAW_CONFIG_DIR}/config/agent.yaml"

# 设置权限
echo "🔒 设置文件权限..."
chmod 600 "${OPENCLAW_CONFIG_DIR}/config/"*.yaml
chmod 700 "${OPENCLAW_CONFIG_DIR}/backup/clawcook"

# 离线模式跳过网络操作
if [ "$OFFLINE" = false ]; then
    echo "🌐 更新 OpenClaw 技能和智能体索引..."
    openclaw skills update --all || echo "⚠️  技能索引更新失败，跳过"
    openclaw agents update --all || echo "⚠️  智能体索引更新失败，跳过"
fi

# 安装完成
echo -e "\n🎉 ${GREEN}Claw Cooking 基础环境安装完成！${NC}"
echo "=========================================="
echo ""
echo "📝 接下来需要完成以下配置："
echo "1. 编辑模型配置: ${OPENCLAW_CONFIG_DIR}/config/models.yaml"
echo "2. 编辑渠道配置: ${OPENCLAW_CONFIG_DIR}/config/channels/channel.yaml"
echo "3. 编辑安全配置: ${OPENCLAW_CONFIG_DIR}/config/security.yaml"
echo "4. （可选）自定义智能体名称: ${OPENCLAW_CONFIG_DIR}/config/agent.yaml"
echo ""
echo "🚀 配置完成后运行部署脚本: ./scripts/deploy.sh"
echo ""
echo "❓ 如有问题请查看文档: docs/ 目录或提交 Issue"
