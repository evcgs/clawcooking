# 快速开始：三步煮龙虾
## 前置要求
### 系统要求
- macOS 12+ / Linux (Ubuntu 20.04+ / CentOS 8+ / Debian 11+)
- Windows 10+ (WSL2 环境)
- 硬件配置：CPU 2核+，内存 4GB+，磁盘 20GB+

### 提前准备
1. OpenClaw 已经安装完成（如果还没装，先看 [安装指南](installation.md)）
2. 至少有一个可用的 AI 模型 API 密钥（豆包/Ark/GPT/Ollama 都可以）
3. 飞书应用已经创建好（如果不用飞书可以跳过）

---

## 第一步：准备食材
```bash
# 1. 克隆项目
git clone https://github.com/pandonglin/clawcook.git
cd clawcook

# 2. 检查环境
openclaw --version
# 预期输出：OpenClaw version x.x.x
```

---

## 第二步：处理食材
### 2.1 一键安装依赖
```bash
# 运行一键安装脚本，自动安装所有依赖和配置基础环境
./scripts/install.sh
```

脚本会自动完成：
- 检查 OpenClaw 环境
- 安装所有系统依赖
- 创建工作目录结构
- 复制基础配置模板

### 2.2 填写必填配置
只需要修改 3 个配置文件，其他全部已经预配置好了：

#### ① 模型配置 `recipes/base/model.yaml`
```yaml
default_model: "your-model-id"
models:
  - id: "your-model-id"
    name: "Your Model Name"
    provider: "ark/openai/ollama"
    api_key: "your-api-key"  # 填入你的API密钥
    base_url: "your-api-endpoint"
```

#### ② 渠道配置 `recipes/base/channel.yaml`（以飞书为例）
```yaml
feishu:
  enabled: true
  app_id: "your-app-id"        # 填入飞书应用的app_id
  app_secret: "your-app-secret" # 填入飞书应用的app_secret
  encrypt_key: "your-encrypt-key"
  verification_token: "your-verification-token"
  allowed_users:
    - "your-user-open-id"      # 填入你的飞书用户open_id
```

#### ③ 安全配置 `recipes/base/security.yaml`
```yaml
authorization:
  allowed_users:
    - "your-user-open-id"      # 填入你的用户ID，只允许你自己访问
```

✅ 配置完成！你已经完成了所有必填项的配置。

---

## 第三步：出锅享用
### 3.1 一键部署所有智能体和技能
```bash
./scripts/deploy.sh
```
脚本会自动完成：
- 安装 6 大核心智能体
- 安装 4 大技能包
- 配置智能体权限和通信规则
- 导入预定义工作流

### 3.2 一键启动服务
```bash
./scripts/start.sh
```

### 3.3 验证安装
1. 查看服务状态：`openclaw gateway status`
2. 在飞书中给机器人发送 `/status`
3. 预期返回：系统状态、版本、内存使用等信息

🎉 恭喜！你已经完成了 Claw Cooking 的安装，现在可以开始享用美味的AI龙虾了！

---

## 下一步
- 查看 [智能体使用说明](../recipes/chefs/)，了解每个大厨的能力
- 查看 [技能包使用说明](../recipes/seasonings/)，了解每个调料包的功能
- 查看 [最佳实践菜单](../menus/)，学习常用工作流的使用
- 加入我们的社区，和其他用户交流使用经验

---

## 常见问题
### Q：安装过程中报错怎么办？
A：先看 [常见问题](faq.md)，如果没有解决，可以提交 Issue 寻求帮助。

### Q：可以只安装部分智能体吗？
A：可以，修改 `deploy.sh` 脚本，注释掉不需要的智能体即可。

### Q：怎么添加自己的自定义技能？
A：把你的技能放到 `recipes/seasonings/custom/` 目录下，重新运行 `deploy.sh` 即可。
