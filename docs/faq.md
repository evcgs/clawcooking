# 常见问题 FAQ
## 🚀 安装相关
### Q1：安装过程中提示权限不足怎么办？
A：
```bash
# 给脚本添加执行权限
chmod +x scripts/*.sh

# 如果是系统目录权限问题，使用sudo运行
sudo ./scripts/install.sh
```

### Q2：OpenClaw 安装失败怎么办？
A：
- 检查网络连接是否正常
- 检查 Homebrew/Linuxbrew 是否正常工作
- 尝试手动下载安装包安装：https://github.com/openclaw/openclaw/releases

### Q3：飞书应用审核不通过怎么办？
A：
- 检查是否开通了所有需要的权限
- 确保应用名称和描述符合企业规范
- 如果是个人使用，可以申请测试版本，不需要审核

---

## ⚙️ 配置相关
### Q1：怎么获取我的飞书用户 open_id？
A：
方法1：在飞书中给机器人发送任意消息，查看网关日志中的 `sender_id` 字段
方法2：使用飞书开放平台的「获取用户ID」工具
方法3：联系企业管理员查询

### Q2：API 密钥怎么保管更安全？
A：
- 不要把密钥提交到 Git 仓库，`.gitignore` 已经默认排除了本地配置文件
- 可以使用环境变量存储密钥，配置文件中引用环境变量
- 定期轮换 API 密钥

### Q3：可以同时配置多个模型吗？
A：可以，在 `model.yaml` 中添加多个模型配置即可，使用时可以通过指令切换模型。

### Q4：可以同时配置多个渠道吗？
A：可以，支持同时配置飞书、微信、Telegram、Discord 等多个渠道。

---

## 🤖 智能体相关
### Q1：智能体安装失败怎么办？
A：
```bash
# 查看安装日志
openclaw agents logs <agent-name>

# 尝试重新安装
openclaw agents reinstall <agent-name>
```

### Q2：怎么自定义智能体的能力？
A：
- 修改对应智能体的配置文件 `recipes/chefs/<chef-name>/config.yaml`
- 添加自定义的系统提示词和技能
- 重新部署智能体：`./scripts/deploy.sh --only <agent-name>`

### Q3：智能体之间可以通信吗？
A：默认已经配置了智能体之间的通信权限，你可以在 `security.yaml` 中自定义通信规则。

### Q4：怎么添加自定义智能体？
A：
1. 在 `recipes/chefs/` 目录下创建新的智能体目录
2. 参考已有智能体的结构编写配置和文档
3. 运行部署脚本安装新智能体

---

## 🔌 技能相关
### Q1：技能包安装失败怎么办？
A：
```bash
# 查看技能安装日志
openclaw skills logs <skill-name>

# 尝试重新安装
openclaw skills reinstall <skill-name>
```

### Q2：怎么添加自定义技能？
A：
1. 在 `recipes/seasonings/` 目录下创建新的技能包目录
2. 参考已有技能包的结构编写配置和文档
3. 运行部署脚本安装新技能包

### Q3：可以使用 ClawHub 上的第三方技能吗？
A：可以，直接在部署脚本中添加对应的技能 ID 即可。

### Q4：飞书文档读取失败怎么办？
A：
- 检查飞书应用是否开通了文档相关权限
- 检查文档是否对应用可见
- 检查 `doc_token` 是否正确

---

## 🔒 安全相关
### Q1：数据会上传到云端吗？
A：不会，所有数据 100% 本地运行，不会上传到任何第三方服务器。

### Q2：怎么确保操作安全？
A：
- 默认配置了三级权限体系，高风险操作需要人工确认
- 开启全量操作审计，所有操作都有日志记录
- 定期运行安全巡检：`./scripts/security-check.sh`

### Q3：可以给团队使用吗？
A：可以，配置 `security.yaml` 中的 `allowed_users` 白名单，添加团队成员的用户 ID 即可。

### Q4：怎么备份数据？
A：
```bash
# 运行一键备份脚本
./scripts/backup.sh

# 备份文件默认保存在 ~/.openclaw/backup/ 目录下
```

---

## 🐛 故障排查
### Q1：机器人收不到消息怎么办？
A：
1. 检查网关服务状态：`openclaw gateway status`
2. 检查飞书事件订阅配置是否正确
3. 检查网络是否能访问到网关服务
4. 查看网关日志：`tail -f ~/.openclaw/logs/gateway.log`

### Q2：机器人回复很慢怎么办？
A：
- 检查模型 API 的响应速度
- 减少智能体的上下文窗口大小
- 升级硬件配置，使用更快的模型

### Q3：智能体调用工具失败怎么办？
A：
- 检查工具权限配置是否正确
- 查看智能体日志：`openclaw agents logs <agent-name>`
- 确认工具是否正常安装

### Q4：怎么查看系统日志？
A：
```bash
# 网关日志
tail -f ~/.openclaw/logs/gateway.log

# 会话日志
tail -f ~/.openclaw/logs/sessions/<session-id>.log

# 智能体日志
openclaw agents logs <agent-name>

# 技能日志
openclaw skills logs <skill-name>
```

---

## 📈 性能优化
### Q1：怎么提升响应速度？
A：
- 使用更快的模型 API 或者本地模型
- 减少上下文长度
- 关闭不需要的智能体和技能
- 升级硬件配置

### Q2：怎么减少内存占用？
A：
- 关闭不需要的智能体
- 减少每个智能体的最大上下文数量
- 定期清理历史会话：`openclaw sessions prune`

### Q3：怎么支持更多用户同时使用？
A：
- 升级服务器配置
- 使用分布式部署
- 配置负载均衡

---

如果你的问题没有在上面找到答案，可以提交 Issue 或者加入社区寻求帮助。
