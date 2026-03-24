# Q: 最近很火的 OpenClaw 是什么？

> **关键词**：OpenClaw、个人AI助手、开源、多渠道、Agent、Gateway、Skills、MCP

---

## 简短回答

**OpenClaw** 是一个开源的个人 AI 助手平台，你可以在自己的设备上运行它，然后通过 WhatsApp、Telegram、Slack、Discord、微信等 20 多个渠道与它对话。它不只是聊天机器人，而是一个具备工具调用、浏览器控制、语音交互、多智能体协作能力的完整 AI Agent 系统。GitHub 上已获得 **33万+ Star**，是目前最火的开源 AI 项目之一。

---

## 详细分析

### 1. OpenClaw 是什么

OpenClaw 是一个**本地优先（Local-first）的个人 AI 助手**，核心理念是：

> 你拥有自己的 AI 助手，它运行在你自己的设备上，通过你已经在用的聊天渠道跟你交互。

它不是一个云服务，而是一个**你自己部署和控制的 AI 系统**。你可以把它理解为"自己搭建的私人 ChatGPT"，但比 ChatGPT 强大得多，因为它能：
- 连接你的消息渠道（WhatsApp、Telegram 等）
- 调用工具（浏览器、代码执行、文件操作等）
- 控制你的设备（macOS、iOS、Android）
- 具备记忆和持续运行能力

### 2. 核心架构

```
WhatsApp / Telegram / Slack / Discord / Signal / 微信 / ...
                        │
                        ▼
         ┌──────────────────────────┐
         │       Gateway            │
         │    （控制平面）            │
         │   ws://127.0.0.1:18789   │
         └────────────┬─────────────┘
                      │
          ┌───────────┼───────────┐
          │           │           │
          ▼           ▼           ▼
     Pi Agent     CLI 命令行   macOS/iOS/
     (AI推理)     (openclaw …)  Android App
```

| 组件 | 作用 |
|------|------|
| **Gateway** | 核心控制平面，管理所有会话、渠道、工具和事件，类似于一个本地服务器 |
| **Pi Agent** | AI 推理引擎，通过 RPC 模式运行，支持工具流式调用 |
| **Channels** | 22+ 个消息渠道适配器（WhatsApp、Telegram、Slack、Discord 等） |
| **Skills** | 可扩展的技能系统，类似于 AI 的"插件" |
| **Nodes** | 设备节点（macOS/iOS/Android），让 AI 能控制你的设备 |

### 3. 核心能力

#### 3.1 多渠道接入（22+ 渠道）

这是 OpenClaw 最大的卖点之一。它支持几乎所有主流消息平台：

```
WhatsApp / Telegram / Slack / Discord / Google Chat / Signal /
iMessage / IRC / Microsoft Teams / Matrix / Feishu（飞书） /
LINE / Mattermost / Nostr / Twitch / WebChat / ...
```

你只需要在一个地方配置 AI，就能在所有渠道使用它。

#### 3.2 AI Agent 能力

OpenClaw 不仅仅是聊天，它是一个完整的 **AI Agent**：

| 能力 | 说明 |
|------|------|
| **浏览器控制** | 可以打开网页、截图、点击、填表，用专门的 Chrome 实例 |
| **代码执行** | 可以执行 bash 命令、运行脚本 |
| **文件操作** | 读写本地文件 |
| **定时任务** | Cron 调度 + Webhook 触发 |
| **设备控制** | 通过 Node 控制 macOS/iOS/Android 设备（截图、录屏、定位、通知等） |
| **多会话** | 不同渠道/群组有独立的会话上下文 |
| **多智能体** | Agent to Agent 通信，跨会话协作 |

#### 3.3 技能系统（Skills + ClawHub）

OpenClaw 有一个类似"应用商店"的技能系统：

- **内置技能**：预装的基础能力
- **ClawHub**：技能注册中心，AI 可以自动搜索和安装需要的技能
- **自定义技能**：放在 `~/.openclaw/workspace/skills/` 下的自定义 SKILL.md

#### 3.4 语音交互

- **Voice Wake**：macOS/iOS 上的唤醒词
- **Talk Mode**：Android 上的持续语音对话
- 支持 ElevenLabs + 系统 TTS

#### 3.5 Canvas（可视化画布）

一个 AI 驱动的可视化工作区（A2UI），AI 可以主动推送内容到画布上展示。

### 4. 技术栈分析

| 方面 | 技术选择 |
|------|---------|
| **主语言** | TypeScript（核心项目）+ Python（技能系统）+ Swift（macOS/iOS） |
| **包管理** | pnpm（推荐）/ npm / bun |
| **运行时** | Node.js 24（推荐）或 Node 22.16+ |
| **通信** | WebSocket（Gateway 控制平面） |
| **AI 模型** | 支持多种模型（OpenAI、Anthropic Claude、Google Gemini 等），推荐最新最强模型 |
| **部署** | 本地运行 / Docker / Nix / 远程 Linux 服务器 |
| **安全** | DM 配对机制、沙箱模式（Docker）、Tailscale 安全暴露 |

### 5. 安装和使用

非常简单：

```bash
# 安装
npm install -g openclaw@latest

# 引导式配置（一步步设置 Gateway、渠道、技能）
openclaw onboard --install-daemon

# 启动
openclaw gateway --port 18789 --verbose

# 发消息
openclaw message send --to +1234567890 --message "Hello"

# 跟 AI 对话
openclaw agent --message "帮我写个周报" --thinking high
```

### 6. 为什么这么火？

| 原因 | 分析 |
|------|------|
| **开源** | MIT 协议，完全免费，社区驱动（33万+ Star，6.5万+ Fork） |
| **隐私** | 本地运行，数据不上传到任何云服务 |
| **全渠道** | 一个助手覆盖所有聊天平台，不需要在每个平台单独配 AI |
| **真正的 Agent** | 不只是聊天，能操作浏览器、执行代码、控制设备 |
| **可扩展** | Skills 系统让社区可以贡献各种能力 |
| **开发体验好** | CLI 驱动、引导式配置、完善的文档 |
| **赞助商强** | OpenAI、Vercel 等大厂赞助 |

### 7. 与同类产品对比

| 特性 | OpenClaw | ChatGPT | 其他开源方案（如 Jan、Ollama） |
|------|---------|---------|-------------------------------|
| 多渠道接入 | 22+ 渠道 | 仅网页/App | 通常仅 Web UI |
| 本地运行 | 是 | 否（云端） | 是 |
| 工具调用 | 浏览器、代码、设备控制等 | 有限 | 通常较少 |
| 模型选择 | 任意模型 | 仅 OpenAI | 通常仅本地模型 |
| 设备控制 | macOS/iOS/Android | 否 | 否 |
| 多智能体 | 是 | 否 | 通常不支持 |
| 技能扩展 | ClawHub 生态 | GPTs 商店 | 有限 |

### 8. 适合谁用

- **技术爱好者**：想要一个自己控制的 AI 助手
- **开发者**：需要 AI Agent 能力来自动化日常工作
- **隐私敏感用户**：不希望数据上传到云端
- **多平台用户**：希望在所有聊天平台统一使用 AI

### 9. 局限性

- **需要技术基础**：安装配置需要 Node.js、命令行操作等技能
- **需要 API Key**：AI 模型仍需要调用云端 API（OpenAI/Anthropic 等），有使用成本
- **资源消耗**：Gateway 常驻运行，占用一定系统资源
- **安全风险**：连接真实消息渠道，需要仔细配置 DM 策略，防止未授权访问

---

## 总结

OpenClaw 代表了 AI 助手的一个重要方向：**从云端聊天框走向本地化、全渠道、具备真正行动能力的个人 AI Agent**。它的开源属性和强大的社区生态使其快速成为目前最热门的 AI 项目之一。

从 AI 知识体系的角度看，OpenClaw 是我们教材中 [06-大语言模型](../06-大语言模型LLM/README.md) 章节提到的 **AI Agent** 概念的一个典型落地产品——LLM + 工具调用 + 规划 + 记忆 = Agent。

---

## 相关章节

- [06 - 大语言模型 (LLM) — 6.6 AI Agent](../06-大语言模型LLM/README.md)
- [07 - AI 实践与工具](../07-AI实践与工具/README.md)
