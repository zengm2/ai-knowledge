# Q: 最近很火的 OpenClaw 是什么？它的架构设计、代码结构和核心设计是怎样的？

> **关键词**：OpenClaw、个人AI助手、开源、多渠道、Agent、Gateway、Skills、MCP、架构设计、代码结构、WebSocket、Pi Agent

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

## 深入分析：架构设计、代码结构与核心设计

### 10. 项目源码结构总览

OpenClaw 是一个 **TypeScript monorepo**，使用 pnpm workspace 管理。总计 21,775+ commits，代码组织如下：

```
openclaw/
├── src/                    # 核心源码（40+ 模块）
├── apps/                   # 客户端应用（macOS/iOS/Android）
├── packages/               # 共享 npm 包
├── extensions/             # 扩展/插件
├── ui/                     # Web UI（Control UI + WebChat）
├── skills/                 # 内置技能
├── docs/                   # 文档
├── Swabble/                # macOS 原生应用（Swift）
├── test/                   # 端到端测试
├── scripts/                # 构建和工具脚本
├── vendor/a2ui/            # A2UI 可视化引擎
├── .pi/                    # Pi Agent 配置
├── docker-compose.yml      # Docker 部署
├── package.json            # 项目根配置
├── pnpm-workspace.yaml     # monorepo 工作区
└── tsconfig.json           # TypeScript 配置
```

### 11. src/ 核心代码架构（重点）

`src/` 是整个项目的心脏，包含 **40+ 个功能模块**，按职责清晰划分：

```
src/
│
├── ========== 核心引擎层 ==========
├── gateway/            # Gateway 核心（WebSocket 服务器、控制平面）
├── agents/             # Agent 运行时（多Agent管理、配置）
├── sessions/           # 会话管理（session 生命周期、状态、持久化）
├── routing/            # 消息路由（渠道→会话→Agent 的分发逻辑）
├── context-engine/     # 上下文引擎（Prompt 组装、系统提示、上下文管理）
├── config/             # 配置系统（openclaw.json 解析、校验、热加载）
│
├── ========== 渠道适配层 ==========
├── channels/           # 渠道核心框架
│   ├── allowlists/     # 白名单管理
│   ├── plugins/        # 渠道插件（WhatsApp/Telegram/Slack/Discord 等 22+ 个）
│   ├── transport/      # 消息传输抽象
│   └── web/            # WebChat 渠道
├── line/               # LINE 渠道专属模块
│
├── ========== 工具与能力层 ==========
├── browser/            # 浏览器控制（CDP 协议操控 Chrome）
├── canvas-host/        # Canvas 可视化画布（A2UI 宿主）
├── web-search/         # Web 搜索工具
├── image-generation/   # 图像生成工具
├── link-understanding/ # URL 内容理解
├── media-understanding/# 多媒体理解（图片/音频/视频）
├── media/              # 媒体处理管道
├── tts/                # 文本转语音（Text-to-Speech）
├── memory/             # 记忆系统（长期/短期记忆）
├── cron/               # 定时任务系统
│
├── ========== 扩展与插件层 ==========
├── plugins/            # 插件运行时
├── plugin-sdk/         # 插件开发 SDK
├── extensions/         # 扩展管理器
├── hooks/              # 钩子系统（事件拦截与注入）
│
├── ========== 设备与节点层 ==========
├── node-host/          # 设备节点宿主（管理 macOS/iOS/Android 节点）
├── pairing/            # 设备配对系统（安全配对流程）
│
├── ========== CLI 与交互层 ==========
├── cli/                # CLI 框架
├── commands/           # CLI 子命令实现
├── wizard/             # 引导式安装向导（onboard）
├── interactive/        # 交互式终端
├── tui/                # 终端 UI 组件
├── terminal/           # 终端工具
│
├── ========== 基础设施层 ==========
├── acp/                # Agent Client Protocol 实现
├── bindings/           # 原生绑定
├── bootstrap/          # 启动引导
├── daemon/             # 守护进程管理（launchd/systemd）
├── infra/              # 基础设施工具
├── logging/            # 日志系统
├── secrets/            # 密钥管理
├── security/           # 安全模块（沙箱、权限、DM策略）
├── process/            # 进程管理
├── shared/             # 共享工具函数
├── types/              # TypeScript 类型定义
├── utils/              # 通用工具
├── i18n/               # 国际化
├── compat/             # 兼容性层
├── markdown/           # Markdown 处理
├── auto-reply/         # 自动回复
├── docs/               # 文档生成工具
├── scripts/            # 内部脚本
├── test-helpers/       # 测试辅助
├── test-utils/         # 测试工具
│
├── ========== 入口文件 ==========
├── entry.ts            # 主入口
├── entry.respawn.ts    # 进程重启入口
├── index.ts            # 库入口
├── library.ts          # 库模式入口
├── runtime.ts          # 运行时初始化
├── globals.ts          # 全局变量
├── extensionAPI.ts     # 扩展 API 入口
└── logger.ts           # 日志初始化
```

### 12. Gateway 架构设计（核心中的核心）

Gateway 是 OpenClaw 的**大脑和中枢**，所有组件都通过它协调。

#### 12.1 整体架构图

```
  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
  │  WhatsApp    │  │  Telegram   │  │    Slack     │  │  Discord    │  ... 22+ 渠道
  │  (Baileys)   │  │  (grammY)   │  │   (Bolt)    │  │(discord.js) │
  └──────┬───────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘
         │                 │                 │                 │
         └────────────────┬┴─────────────────┴─────────────────┘
                          │
                          ▼
         ┌─────────────────────────────────────────┐
         │           Gateway（控制平面）              │
         │         ws://127.0.0.1:18789             │
         │                                          │
         │  ┌──────────┐  ┌──────────┐  ┌────────┐ │
         │  │ WS Server│  │ Routing  │  │Sessions│ │
         │  │ (协议层)  │  │ (路由)   │  │ (会话) │ │
         │  └──────────┘  └──────────┘  └────────┘ │
         │  ┌──────────┐  ┌──────────┐  ┌────────┐ │
         │  │ Pi Agent │  │  Cron    │  │ Hooks  │ │
         │  │ (AI推理)  │  │ (定时)  │  │ (钩子) │ │
         │  └──────────┘  └──────────┘  └────────┘ │
         │  ┌──────────┐  ┌──────────┐  ┌────────┐ │
         │  │ Tools    │  │ Security │  │ Config │ │
         │  │ (工具集)  │  │ (安全)   │  │ (配置) │ │
         │  └──────────┘  └──────────┘  └────────┘ │
         └─────────────┬──────────┬────────────────┘
                       │          │
          ┌────────────┤          ├────────────┐
          ▼            ▼          ▼            ▼
     ┌─────────┐ ┌─────────┐ ┌────────┐ ┌─────────┐
     │ CLI     │ │ macOS   │ │ WebChat│ │iOS/Droid│
     │ Client  │ │  App    │ │  UI    │ │  Node   │
     └─────────┘ └─────────┘ └────────┘ └─────────┘
```

#### 12.2 WebSocket 协议设计

Gateway 使用**自定义的 WebSocket JSON 协议**，所有通信走统一的 WS 连接：

**帧格式**：
```
请求帧: { type: "req",   id: "...", method: "...", params: {...} }
响应帧: { type: "res",   id: "...", ok: true/false, payload|error: {...} }
事件帧: { type: "event", event: "...", payload: {...}, seq?, stateVersion? }
```

**连接握手流程**：
```
1. 客户端建立 WebSocket 连接
2. Gateway 发送 challenge 事件（含 nonce 随机数）
   → { type: "event", event: "connect.challenge", payload: { nonce: "...", ts: ... } }

3. 客户端发送 connect 请求（含身份、角色、权限、签名）
   → { type: "req", method: "connect", params: {
       role: "operator" | "node",
       scopes: ["operator.read", "operator.write"],
       device: { id: "...", publicKey: "...", signature: "..." },
       auth: { token: "..." }
     }}

4. Gateway 验证并返回 hello-ok
   → { type: "res", payload: { type: "hello-ok", protocol: 3 } }
```

**角色体系**：

| 角色 | 说明 | 典型客户端 |
|------|------|-----------|
| **operator** | 控制平面操作者，可管理和控制 Gateway | CLI、macOS App、Web UI |
| **node** | 能力提供者，暴露设备能力供 Agent 调用 | macOS 节点、iOS、Android |

**关键设计决策**：
- 首帧必须是 `connect`，否则直接断开（安全强制）
- 侧效应方法必须携带幂等键（防重复执行）
- 协议版本协商（`minProtocol`/`maxProtocol`）
- 所有连接必须签名 challenge nonce（防重放攻击）
- TypeBox Schema 定义协议 → 自动生成 JSON Schema + Swift 类型

### 13. Agent Loop 核心设计（AI 推理引擎）

Agent Loop 是 OpenClaw 中 AI 思考和行动的完整流程。

#### 13.1 Agent Loop 生命周期

```
用户消息到达
    │
    ▼
┌──────────────────────────────────────────────┐
│  1. 接收请求 (agent RPC)                      │
│     - 验证参数                                │
│     - 解析 session（sessionKey / sessionId）   │
│     - 持久化 session 元数据                    │
│     - 立即返回 { runId, acceptedAt }          │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────┐
│  2. agentCommand 执行                         │
│     - 解析模型 + thinking/verbose 默认值       │
│     - 加载 Skills 快照                        │
│     - 调用 runEmbeddedPiAgent                 │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────┐
│  3. runEmbeddedPiAgent（核心推理）             │
│     - 通过 session 队列串行化（防竞争）         │
│     - 解析模型 + 认证 profile                  │
│     - 构建 Pi session                         │
│     - 订阅 Pi 事件，流式发送结果               │
│     - 超时保护（默认 600 秒）                  │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────┐
│  4. Prompt 组装                               │
│     - 基础系统提示                            │
│     - + Skills 提示注入                       │
│     - + Bootstrap 上下文文件                   │
│     - + 运行时覆盖                            │
│     - 令牌限制 & 压缩预留                      │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────┐
│  5. 模型推理 + 工具调用循环                    │
│     while (模型需要更多信息) {                  │
│       model.generate() → 输出 / 工具调用       │
│       if (工具调用) {                          │
│         执行工具 → 返回结果 → 继续推理          │
│       }                                       │
│     }                                         │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────┐
│  6. 流式输出                                  │
│     - assistant 文本流 → stream: "assistant"   │
│     - tool 事件流 → stream: "tool"            │
│     - lifecycle 事件 → stream: "lifecycle"    │
│     - 自动压缩 (auto-compaction) 触发重试      │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
         回复送达用户渠道
```

#### 13.2 并发控制（队列设计）

```
Session A 的消息队列:  [msg1] → [msg2] → [msg3]  (串行处理)
Session B 的消息队列:  [msg1] → [msg2]            (与 A 并行)
                              │
                              ▼
                    可选的全局队列 (限制总并发)
```

- 每个 session 有独立的**任务队列**，保证同一会话内串行执行
- 可选全局队列限制总体并发度
- 渠道可选择队列模式：`collect`（收集）、`steer`（引导）、`followup`（跟进）

#### 13.3 钩子系统（Hook Points）

OpenClaw 在 Agent Loop 的关键节点提供了**两套钩子系统**：

**Gateway Hooks**（事件驱动脚本）：
- `agent:bootstrap`：系统提示构建前注入上下文

**Plugin Hooks**（代码级拦截）：

| 钩子 | 触发时机 | 用途 |
|------|---------|------|
| `before_model_resolve` | 模型解析前 | 动态切换模型 |
| `before_prompt_build` | Prompt 组装前 | 注入自定义上下文 |
| `before_tool_call` | 工具执行前 | 拦截/修改工具参数 |
| `after_tool_call` | 工具执行后 | 处理/转换工具结果 |
| `agent_end` | Agent 完成后 | 后处理、日志 |
| `message_received` | 收到消息时 | 消息预处理 |
| `message_sending` | 发送消息前 | 消息后处理 |

### 14. 渠道系统架构

渠道系统采用**插件化适配器模式**，统一抽象消息的收发：

```
src/channels/
├── plugins/          # 22+ 渠道插件，每个渠道一个适配器
│   ├── whatsapp/     # WhatsApp（基于 Baileys 库）
│   ├── telegram/     # Telegram（基于 grammY 框架）
│   ├── slack/        # Slack（基于 Bolt 框架）
│   ├── discord/      # Discord（基于 discord.js）
│   ├── signal/       # Signal（基于 signal-cli）
│   ├── bluebubbles/  # iMessage（通过 BlueBubbles）
│   ├── msteams/      # Microsoft Teams
│   ├── matrix/       # Matrix 协议
│   ├── feishu/       # 飞书
│   ├── irc/          # IRC
│   └── ...           # 更多渠道
├── transport/        # 消息传输抽象层
├── allowlists/       # 白名单和权限管理
└── web/              # WebChat 内置渠道
```

**每个渠道插件遵循统一接口**：
```
接收消息 → 标准化为统一格式 → 路由到正确的 Session → Agent 处理 → 标准化回复 → 转换为渠道格式 → 发送
```

**安全机制**：
- DM 配对策略（`dmPolicy: "pairing"`）：未知发送者需先验证配对码
- 白名单机制（`allowFrom`）：限制谁可以与 AI 对话
- 群组策略（`groups` 配置）：群组级别的访问控制

### 15. 插件与技能系统设计

```
扩展体系
├── Skills（技能）
│   ├── 内置技能（bundled）        # 随项目发布的基础技能
│   ├── 托管技能（managed）        # 通过 ClawHub 分发的官方技能
│   └── 工作区技能（workspace）    # 用户自定义，放在 ~/.openclaw/workspace/skills/
│
├── Plugins（插件）
│   ├── npm 包分发                 # 通过 npm 安装
│   ├── 本地扩展加载               # 开发时使用
│   └── 记忆插件（特殊槽位）       # 同时只能激活一个记忆插件
│
└── MCP 集成
    └── 通过 mcporter 桥接         # 解耦 MCP，不直接内置到核心
        （github.com/steipete/mcporter）
```

**设计哲学**（来自 VISION.md）：
- 核心保持精简，能力尽量通过插件扩展
- 新技能应先发布到 ClawHub，不默认加入核心
- MCP 通过 mcporter 桥接而非内置，减少对核心稳定性的影响

### 16. 安全架构设计

安全是 OpenClaw 架构的第一优先级。

```
安全层次
├── 传输安全
│   ├── WebSocket + TLS（可选证书固定）
│   ├── Challenge-Response 握手（nonce 签名 v3）
│   └── 设备身份绑定（publicKey + fingerprint）
│
├── 认证授权
│   ├── Gateway Token（API 令牌）
│   ├── Device Token（设备令牌，配对后颁发）
│   ├── 角色体系（operator / node）
│   └── 权限范围（scopes: read / write / admin / approvals）
│
├── 运行时安全
│   ├── DM 配对机制（陌生人需配对码验证）
│   ├── 白名单机制（allowFrom 配置）
│   ├── 执行审批（exec approval，高危操作需人工确认）
│   └── Docker 沙箱（非主会话在容器中运行）
│
└── 设备安全
    ├── 本地优先（默认绑定 127.0.0.1）
    ├── Tailscale Serve/Funnel（安全的远程访问）
    └── 签名载荷 v3 绑定 platform + deviceFamily
```

### 17. 设计亮点与工程实践

| 设计点 | 说明 |
|--------|------|
| **单 Gateway 架构** | 一个主机只跑一个 Gateway，避免多实例冲突（如 WhatsApp session） |
| **协议优先** | TypeBox Schema 定义 → 自动生成 JSON Schema + Swift 类型 + 校验逻辑 |
| **流式优先** | Agent 思考、工具调用、回复全程流式，实时推送给客户端 |
| **本地优先** | 默认绑定 loopback，远程访问通过 Tailscale/SSH 隧道 |
| **守护进程** | 通过 launchd（macOS）/ systemd（Linux）管理，保证常驻运行 |
| **幂等设计** | 侧效应操作（send、agent）必须携带幂等键，支持安全重试 |
| **事件驱动** | 全程事件流（agent、chat、presence、health、heartbeat、cron） |
| **终端优先** | 设计上优先 CLI 体验，确保用户能看到所有安全决策 |

---

## 总结

OpenClaw 代表了 AI 助手的一个重要方向：**从云端聊天框走向本地化、全渠道、具备真正行动能力的个人 AI Agent**。它的开源属性和强大的社区生态使其快速成为目前最热门的 AI 项目之一。

从 AI 知识体系的角度看，OpenClaw 是我们教材中 [06-大语言模型](../06-大语言模型LLM/README.md) 章节提到的 **AI Agent** 概念的一个典型落地产品——LLM + 工具调用 + 规划 + 记忆 = Agent。

---

## 相关章节

- [06 - 大语言模型 (LLM) — 6.6 AI Agent](../06-大语言模型LLM/README.md)
- [07 - AI 实践与工具](../07-AI实践与工具/README.md)
