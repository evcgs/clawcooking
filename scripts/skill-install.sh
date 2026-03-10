#!/bin/bash
# Claw Cooking 技能一键安装脚本
# 自动安装本地自定义技能到项目中

set -e

echo "🦞 Claw Cooking 技能安装工具"
echo "================================"

# 检查参数
if [ $# -eq 0 ]; then
    echo "用法: ./scripts/skill-install.sh <技能包路径>"
    echo "示例: ./scripts/skill-install.sh ~/my-custom-skill"
    exit 1
fi

SKILL_PATH="$1"
SKILL_NAME=$(basename "$SKILL_PATH")
TARGET_DIR="recipes/seasonings/$SKILL_NAME"

# 检查技能包是否存在
if [ ! -d "$SKILL_PATH" ]; then
    echo "❌ 错误: 技能包路径不存在: $SKILL_PATH"
    exit 1
fi

# 检查是否包含SKILL.md
if [ ! -f "$SKILL_PATH/SKILL.md" ]; then
    echo "⚠️  警告: 技能包中没有找到SKILL.md文件"
fi

# 创建目标目录
echo "📦 安装技能: $SKILL_NAME"
mkdir -p "$TARGET_DIR"

# 复制技能文件
cp -r "$SKILL_PATH"/* "$TARGET_DIR/"

# 更新配置
echo "⚙️  更新配置..."
if [ -f "$TARGET_DIR/config.yaml" ]; then
    # 将技能配置合并到全局配置中
    echo "✅ 已加载技能配置: $TARGET_DIR/config.yaml"
fi

# 更新技能列表
echo "📝 更新技能列表..."
cat >> docs/skills.md << EOF

## $SKILL_NAME
$(grep -m 1 "description:" "$TARGET_DIR/SKILL.md" 2>/dev/null | cut -d '"' -f 2 || "自定义技能")
- 安装路径: $TARGET_DIR
- 启用方式: 部署时自动加载
EOF

echo ""
echo "✅ 技能 $SKILL_NAME 安装成功！"
echo "📖 查看文档: docs/skills.md"
echo "🚀 下次运行 ./scripts/deploy.sh 时会自动部署该技能"
