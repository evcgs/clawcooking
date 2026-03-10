# 详细安装指南
## 一、安装 OpenClaw
### macOS 安装
```bash
# 1. 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 安装 OpenClaw
brew tap openclaw/openclaw
brew install openclaw

# 3. 验证安装
openclaw --version
```

### Linux 安装
```bash
# 1. 下载安装包
curl -fsSL https://github.com/openclaw/openclaw/releases/latest/download/openclaw-linux-amd64.tar.gz | tar xz

# 2. 安装到系统路径
sudo mv openclaw /usr/local/bin/

# 3. 验证安装
openclaw --version
```

### Windows (WSL2) 安装
```bash
# 1. 启用 WSL2 并安装 Ubuntu
# 2. 在 Ubuntu 中按照 Linux 安装步骤操作
```

## 二、安装 Claw Cooking
### 方法1：Git 克隆（推荐）
```bash
git clone https://github.com/pandonglin/clawcook.git
cd clawcook
```

### 方法2：下载压缩包
```bash
curl -fsSL https://github.com/pandonglin/clawcook/archive/refs/heads/main.tar.gz | tar xz
cd clawcook-main
```

## 三、环境检查
运行环境检查脚本，确保所有依赖都已安装：
```bash
./scripts/install.sh --check
```

输出示例：
```
✅ OpenClaw 版本: 1.8.0
✅ Node.js 版本: 25.6.1
✅ Git 版本: 2.44.0
✅ 工作目录权限: 正常
✅ 网络连接: 正常
```

如果有任何一项不通过，请先解决对应问题再继续。

## 四、高级安装选项
### 自定义安装路径
```bash
export CLAWCOOK_HOME=/path/to/your/custom/path
./scripts/install.sh
```

### 离线安装
如果你的环境无法访问外网，可以提前下载好所有依赖包：
```bash
# 1. 在有网络的环境下下载依赖
./scripts/install.sh --download-only

# 2. 将整个 clawcook 目录复制到离线环境
# 3. 在离线环境运行安装
./scripts/install.sh --offline
```

### 仅安装核心组件
如果你不需要所有智能体和技能，可以选择安装核心组件：
```bash
# 仅安装核心智能体（PM/BA/Code）
./scripts/deploy.sh --core

# 仅安装指定技能包
./scripts/deploy.sh --only feishu-pack,office-pack
```

## 五、飞书应用创建指南
如果你使用飞书作为交互渠道，需要先创建飞书应用：

### 1. 创建企业自建应用
1. 访问 [飞书开放平台](https://open.feishu.cn/)
2. 点击「创建企业自建应用」
3. 填写应用名称：Claw Cooking
4. 上传应用图标（可以用 assets/logo.png）
5. 点击「创建」

### 2. 开通权限
在「权限管理」中开通以下权限：
- `docx:document`（文档读写）
- `docx:document:readonly`（文档只读）
- `drive:drive`（云盘操作）
- `im:message`（消息发送）
- `im:message:send_as_bot`（以机器人身份发送消息）
- `im:chat`（群组操作）
- `contact:user.base:readonly`（用户信息读取）

### 3. 配置事件订阅
在「事件订阅」中：
- 事件回调地址：`https://your-domain.com/webhook/feishu`（如果是本地测试可以用内网穿透）
- 加密密钥：自己生成一个随机字符串，填入配置文件
- 验证令牌：自己生成一个随机字符串，填入配置文件
- 订阅事件：`接收消息v2.0`

### 4. 发布版本
1. 点击「版本管理与发布」
2. 创建新版本，填写版本信息
3. 申请发布，等待企业管理员审核通过
4. 审核通过后，应用就可以使用了

## 六、模型接入指南
### 字节跳动 Ark 模型（推荐）
```yaml
- id: "custom-ark-cn-beijing-volces-com/ark-code-latest"
  name: "字节跳动 CodeLlama"
  provider: "ark"
  api_key: "your-ark-api-key"
  base_url: "https://ark.cn-beijing.volces.com/api/v3"
```

### OpenAI GPT 模型
```yaml
- id: "gpt-4o"
  name: "OpenAI GPT-4o"
  provider: "openai"
  api_key: "your-openai-api-key"
  base_url: "https://api.openai.com/v1"
```

### 豆包模型
```yaml
- id: "doubao-pro-4k"
  name: "豆包4.0"
  provider: "openai"
  api_key: "your-doubao-api-key"
  base_url: "https://ark.cn-beijing.volces.com/api/v3"
```

### 本地 Ollama 模型
```yaml
- id: "llama3:8b"
  name: "Llama 3 8B"
  provider: "ollama"
  base_url: "http://localhost:11434/v1"
  api_key: "ollama" # 随便填，本地模型不需要密钥
```

## 七、验证安装
安装完成后，运行验证脚本：
```bash
./scripts/install.sh --verify
```

全部检查项通过后，就可以开始使用了。
