# 📦 技能包管理
## 内置技能包
项目已经内置4大核心技能包，开箱即用：
| 技能包 | 功能说明 | 路径 |
|--------|----------|------|
| 📨 飞书全家桶 | 飞书文档/消息/群/日历/知识库/多维表格等全部能力 | recipes/seasonings/feishu-pack/ |
| 📝 办公自动化 | 文档处理、格式转换、自动排版、邮件生成等 | recipes/seasonings/office-pack/ |
| 📊 数据处理 | 数据分析、统计、可视化、SQL查询、报表生成等 | recipes/seasonings/data-pack/ |
| 🔒 安全运维 | 系统检查、备份、安全扫描、日志分析等 | recipes/seasonings/security-pack/ |
## 用户自定义技能安装
### 一键安装用户自定义技能
项目提供了一键安装脚本，可以快速安装你本地开发的创新技能：
```bash
# 安装用户自定义技能
./scripts/skill-install.sh <用户本地技能包路径>
# 示例：安装本地的my-custom-skill技能
./scripts/skill-install.sh ~/my-custom-skill
```
### 技能包规范
用户自定义技能包需要符合以下结构：
```
my-custom-skill/
├── SKILL.md          # 技能说明文档（必填）
├── config.yaml       # 技能配置文件（可选）
├── tools/            # 自定义工具定义（可选）
└── scripts/          # 技能相关脚本（可选）
```
### 技能部署
安装完用户自定义技能后，运行部署脚本即可自动加载：
```bash
./scripts/deploy.sh
```
部署完成后，所有智能体就可以自动调用新安装的技能了~
> ℹ️ 安全提示：安装技能不会覆盖主Agent记忆、对话历史和现有配置，只会新增技能文件，不影响原有数据。
> 详细安全说明请查看：[安全与数据说明](security.md)
## 技能市场
更多官方技能可以从OpenClaw技能商店下载：https://clawhub.com
