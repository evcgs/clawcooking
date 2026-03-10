#!/bin/bash
set -e

# Claw Cooking 一键启动脚本
echo "🦞 启动 Claw Cooking 服务..."
echo "=========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查配置文件
echo -e "🔍 检查配置文件..."
if [ ! -f "${HOME}/.openclaw/config/models.yaml" ]; then
    echo -e "❌ ${RED}模型配置文件不存在，请先运行 install.sh 和 deploy.sh${NC}"
    exit 1
fi

# 检查网关状态
echo -e "\n🚦 检查网关状态..."
if openclaw gateway status | grep -q "running"; then
    echo -e "⚠️  ${YELLOW}网关已经在运行，是否重启？(y/n)${NC}"
    read -r restart
    if [[ "$restart" =~ ^[Yy]$ ]]; then
        echo "🔄 重启网关服务..."
        openclaw gateway restart
    else
        echo "✅ 使用现有网关服务"
    fi
else
    echo "🚀 启动网关服务..."
    openclaw gateway start
fi

# 等待网关启动
echo -e "\n⏳ 等待网关启动..."
sleep 3

# 验证网关状态
echo -e "\n✅ 验证服务状态..."
if openclaw gateway status | grep -q "running"; then
    echo -e "✅ ${GREEN}网关服务运行正常${NC}"
else
    echo -e "❌ ${RED}网关服务启动失败，请检查日志${NC}"
    echo "📝 日志路径: ~/.openclaw/logs/gateway.log"
    exit 1
fi

# 检查智能体状态
echo -e "\n🤖 检查智能体状态..."
agents=$(openclaw agents list | grep -v "NAME" | awk '{print $1}')
for agent in $agents; do
    if openclaw agents status "$agent" | grep -q "running"; then
        echo -e "✅ ${agent}: 运行正常"
    else
        echo -e "🔄 ${agent}: 正在启动..."
        openclaw agents start "$agent"
        sleep 1
        if openclaw agents status "$agent" | grep -q "running"; then
            echo -e "✅ ${agent}: 启动成功"
        else
            echo -e "⚠️  ${YELLOW}${agent}: 启动失败，跳过${NC}"
        fi
    fi
done

# 启动完成
echo -e "\n🎉 ${GREEN}Claw Cooking 启动完成！${NC}"
echo "=========================================="
echo ""
echo "📊 服务状态："
echo "网关服务：$(openclaw gateway status | grep "Status" | awk '{print $2}')"
echo "运行智能体：$(openclaw agents list | grep "running" | wc -l) 个"
echo "监听端口：$(openclaw gateway status | grep "Port" | awk '{print $2}')"
echo ""
echo "💡 使用方法："
echo "1. 在飞书中给机器人发送消息即可开始使用"
echo "2. 查看服务状态: openclaw gateway status"
echo "3. 查看智能体状态: openclaw agents list"
echo "4. 查看日志: tail -f ~/.openclaw/logs/gateway.log"
echo "5. 停止服务: openclaw gateway stop"
echo ""
echo "🍤 祝你用餐愉快！"
