#!/bin/bash
set -e

# Claw Cooking 一键部署脚本
echo "🦞 开始部署 Claw Cooking 智能体和技能..."
echo "=========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 变量定义
CLAWCOOK_HOME="${CLAWCOOK_HOME:-$(pwd)}"
OPENCLAW_CONFIG_DIR="${HOME}/.openclaw"
CORE_ONLY=false
ONLY_COMPONENTS=""

# 参数解析
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --core) CORE_ONLY=true ;;
        --only) ONLY_COMPONENTS="$2"; shift ;;
        *) echo "未知参数: $1"; exit 1 ;;
    esac
    shift
done

# 函数：安装智能体
install_agent() {
    local agent_id=$1
    local agent_dir=$2
    local agent_key=$(echo "$agent_id" | tr '-' '_')
    local default_name=""
    
    # 从配置文件读取自定义名称
    if [ -f "${OPENCLAW_CONFIG_DIR}/config/agent.yaml" ]; then
        custom_name=$(yq e ".agent_names.${agent_key}" "${OPENCLAW_CONFIG_DIR}/config/agent.yaml" 2>/dev/null || echo "")
    fi
    
    # 确定显示名称
    case $agent_id in
        pm-chef) default_name="PM大厨" ;;
        ba-chef) default_name="BA大厨" ;;
        data-chef) default_name="Data大厨" ;;
        code-chef) default_name="Code大厨" ;;
        doc-chef) default_name="Doc大厨" ;;
        ops-chef) default_name="Ops大厨" ;;
        *) default_name="$agent_id" ;;
    esac
    
    local agent_name="${custom_name:-$default_name}"
    
    echo -e "\n🤖 安装 ${agent_name} (${agent_id})..."
    echo "--------------------------"
    
    # 检查是否已经安装
    if openclaw agents list | grep -q "$agent_id"; then
        echo -e "⚠️  ${YELLOW}${agent_name} 已经安装，跳过${NC}"
        return 0
    fi
    
    # 安装智能体，传入自定义名称
    if openclaw agents install "$agent_id" --config "${agent_dir}/config.yaml" --name "$agent_name"; then
        echo -e "✅ ${GREEN}${agent_name} 安装成功${NC}"
    else
        echo -e "❌ ${RED}${agent_name} 安装失败${NC}"
        return 1
    fi
}

# 函数：安装技能包
install_skill_pack() {
    local pack_name=$1
    local pack_dir=$2
    
    echo -e "\n🧂 安装 ${pack_name}..."
    echo "--------------------------"
    
    # 检查是否已经安装
    if openclaw skills list | grep -q "$pack_name"; then
        echo -e "⚠️  ${YELLOW}${pack_name} 已经安装，跳过${NC}"
        return 0
    fi
    
    # 安装技能包
    if openclaw skills install "$pack_name" --config "${pack_dir}/config.yaml"; then
        echo -e "✅ ${GREEN}${pack_name} 安装成功${NC}"
    else
        echo -e "❌ ${RED}${pack_name} 安装失败${NC}"
        return 1
    fi
}

# 检查是否需要安装组件
should_install() {
    local component=$1
    
    # 如果指定了--only，只安装指定的组件
    if [ -n "$ONLY_COMPONENTS" ]; then
        [[ ",$ONLY_COMPONENTS," == *",$component,"* ]]
        return $?
    fi
    
    # 如果是--core模式，只安装核心组件
    if [ "$CORE_ONLY" = true ]; then
        case $component in
            pm-chef|ba-chef|code-chef|feishu-pack) return 0 ;;
            *) return 1 ;;
        esac
    fi
    
    # 默认安装所有组件
    return 0
}

# 开始部署
echo -e "🔍 检查配置文件..."
if [ ! -f "${OPENCLAW_CONFIG_DIR}/config/models.yaml" ]; then
    echo -e "❌ ${RED}模型配置文件不存在，请先运行 install.sh${NC}"
    exit 1
fi

if [ ! -f "${OPENCLAW_CONFIG_DIR}/config/channels/channel.yaml" ]; then
    echo -e "❌ ${RED}渠道配置文件不存在，请先运行 install.sh${NC}"
    exit 1
fi

if [ ! -f "${OPENCLAW_CONFIG_DIR}/config/security.yaml" ]; then
    echo -e "❌ ${RED}安全配置文件不存在，请先运行 install.sh${NC}"
    exit 1
fi

echo -e "✅ ${GREEN}配置文件检查通过${NC}"

# 安装智能体
echo -e "\n🤖 开始安装智能体..."
echo "--------------------------"

# PM大厨
if should_install "pm-chef"; then
    install_agent "pm-chef" "${CLAWCOOK_HOME}/recipes/chefs/pm-chef"
fi

# BA大厨
if should_install "ba-chef"; then
    install_agent "ba-chef" "${CLAWCOOK_HOME}/recipes/chefs/ba-chef"
fi

# Data大厨
if should_install "data-chef"; then
    install_agent "data-chef" "${CLAWCOOK_HOME}/recipes/chefs/data-chef"
fi

# Code大厨
if should_install "code-chef"; then
    install_agent "code-chef" "${CLAWCOOK_HOME}/recipes/chefs/code-chef"
fi

# Doc大厨
if should_install "doc-chef"; then
    install_agent "doc-chef" "${CLAWCOOK_HOME}/recipes/chefs/doc-chef"
fi

# Ops大厨
if should_install "ops-chef"; then
    install_agent "ops-chef" "${CLAWCOOK_HOME}/recipes/chefs/ops-chef"
fi

# 安装技能包
echo -e "\n🧂 开始安装技能包..."
echo "--------------------------"

# 飞书全家桶
if should_install "feishu-pack"; then
    install_skill_pack "feishu-pack" "${CLAWCOOK_HOME}/recipes/seasonings/feishu-pack"
fi

# 办公自动化
if should_install "office-pack"; then
    install_skill_pack "office-pack" "${CLAWCOOK_HOME}/recipes/seasonings/office-pack"
fi

# 数据处理
if should_install "data-pack"; then
    install_skill_pack "data-pack" "${CLAWCOOK_HOME}/recipes/seasonings/data-pack"
fi

# 安全运维
if should_install "security-pack"; then
    install_skill_pack "security-pack" "${CLAWCOOK_HOME}/recipes/seasonings/security-pack"
fi

# 配置智能体通信
echo -e "\n🔗 配置智能体通信规则..."
echo "--------------------------"
openclaw agents enable-communication

# 导入工作流
echo -e "\n📋 导入预定义工作流..."
echo "--------------------------"
for workflow in "${CLAWCOOK_HOME}/menus/"*.yaml; do
    if [ -f "$workflow" ]; then
        workflow_name=$(basename "$workflow" .yaml)
        if openclaw workflows import "$workflow"; then
            echo -e "✅ ${GREEN}工作流 ${workflow_name} 导入成功${NC}"
        else
            echo -e "⚠️  ${YELLOW}工作流 ${workflow_name} 导入失败，跳过${NC}"
        fi
    fi
done

# 部署完成
echo -e "\n🎉 ${GREEN}Claw Cooking 部署完成！${NC}"
echo "=========================================="
echo ""
echo "📊 已安装组件："
echo "智能体：$(openclaw agents list | wc -l) 个"
echo "技能包：$(openclaw skills list | wc -l) 个"
echo "工作流：$(openclaw workflows list | wc -l) 个"
echo ""
echo "🚀 接下来运行启动脚本: ./scripts/start.sh"
echo ""
echo "💡 使用说明："
echo "- 查看智能体列表: openclaw agents list"
echo "- 查看技能列表: openclaw skills list"
echo "- 查看工作流列表: openclaw workflows list"
echo "- 测试功能: 在飞书中给机器人发送 '/status'"
