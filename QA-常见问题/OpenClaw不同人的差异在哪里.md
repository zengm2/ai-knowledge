# Q: 不同人的 OpenClaw 有什么不同？个性化体现在哪里？

> **关键词**：OpenClaw 个性化、配置定制、SOUL.md、AGENTS.md、Skills、模型选择、渠道配置、记忆系统、工作区

---

## 简短回答

**所有人用的 OpenClaw 代码是同一套，但每个人部署后的 AI 助手完全不一样。** 差异主要体现在 7 个层面：选什么模型、连什么渠道、装什么技能、写什么人格设定、积累什么记忆、装什么插件、怎么配安全策略。你可以把 OpenClaw 理解为一个"AI 助手操作系统"——代码是同一个 OS，但每个人的"桌面、应用、壁纸、文件"都不一样。

---

## 详细解答

### 1. 七层个性化差异全景图

```
┌─────────────────────────────────────────────────────┐
│                    OpenClaw 代码                     │  ← 所有人一样
│                   （同一份开源项目）                   │
└─────────────────────┬───────────────────────────────┘
                      │
        ┌─────────────┼─────────────┐
        ▼             ▼             ▼
  ┌──────────┐  ┌──────────┐  ┌──────────┐
  │  张三的   │  │  李四的   │  │  王五的   │
  │  OpenClaw │  │  OpenClaw │  │  OpenClaw │
  └──────────┘  └──────────┘  └──────────┘

不同的地方（从上到下越来越"个人"）：

第 1 层：模型选择        ← 用 Claude 还是 GPT？
第 2 层：渠道配置        ← 连 WhatsApp 还是 Telegram？
第 3 层：人格设定        ← SOUL.md + IDENTITY.md
第 4 层：行为规则        ← AGENTS.md + TOOLS.md
第 5 层：技能安装        ← 装了哪些 Skills
第 6 层：插件生态        ← 装了哪些 Plugins
第 7 层：记忆积累        ← 对话历史 + memory/ 文件
```

### 2. 第 1 层：模型选择 —— AI 的"智商"不同

不同人可以选不同的底层大模型，这直接决定了 AI 的能力水平：

```json5
// 张三的配置 —— 用 Claude
{
  agents: {
    defaults: {
      model: {
        primary: "anthropic/claude-sonnet-4-6",
        fallbacks: ["openai/gpt-5.2"]
      }
    }
  }
}

// 李四的配置 —— 用 GPT
{
  agents: {
    defaults: {
      model: {
        primary: "openai/gpt-5.2",
        fallbacks: ["anthropic/claude-sonnet-4-6"]
      }
    }
  }
}
```

| 选择 | 影响 |
|------|------|
| 选 Claude | 更擅长长文本、代码、严谨推理 |
| 选 GPT | 更擅长通用对话、创意 |
| 选 Gemini | 更擅长多模态（图像理解等） |
| 选自部署模型 | 完全私有，但能力可能弱一些 |
| 配置 fallback | 主模型挂了自动切备用 |

**甚至可以中途切换**：聊天中用 `/model` 命令实时换模型。

### 3. 第 2 层：渠道配置 —— 在哪里跟 AI 说话

不同人连接不同的聊天渠道：

```json5
// 张三：只用 WhatsApp
{
  channels: {
    whatsapp: {
      enabled: true,
      allowFrom: ["+86138xxxx1234"]
    }
  }
}

// 李四：用 Telegram + Slack + Discord
{
  channels: {
    telegram: {
      enabled: true,
      botToken: "123:abc",
      dmPolicy: "pairing"
    },
    slack: {
      enabled: true,
      // ...
    },
    discord: {
      enabled: true,
      // ...
    }
  }
}
```

**渠道选择的影响**：
- 张三只能在 WhatsApp 上跟 AI 对话
- 李四可以在 3 个平台用同一个 AI，而且它们共享记忆和上下文
- 有人还连了飞书（企业用）、iMessage（苹果生态）、Signal（隐私极客）

### 4. 第 3 层：人格设定 —— AI 的"灵魂"不同

这是差异最大的地方。OpenClaw 工作区里有几个关键文件，定义了 AI "是谁"：

```
~/.openclaw/workspace/
├── SOUL.md         ← AI 的人格、语气、边界
├── IDENTITY.md     ← AI 的名字、风格、表情
├── USER.md         ← 主人是谁、怎么称呼
├── AGENTS.md       ← 操作规则、行为准则
└── TOOLS.md        ← 工具使用偏好
```

#### SOUL.md —— AI 的"灵魂"

这是最核心的个性化文件。不同人写的 SOUL.md 天差地别：

```markdown
# 张三的 SOUL.md（专业助手风格）
你是一个专业的技术助手。
- 用中文回复，偏正式
- 回答要简洁、有条理
- 不要使用emoji
- 遇到不确定的信息，明确告知而不是猜测
```

```markdown
# 李四的 SOUL.md（朋友聊天风格）
你是我的好朋友"小爪"，性格活泼有趣。
- 说话像朋友聊天，可以开玩笑
- 多用emoji 🦞
- 如果我情绪不好，先关心我再回答问题
- 偶尔可以主动分享有趣的事情
```

```markdown
# 王五的 SOUL.md（英语学习伙伴）
You are my English learning partner.
- Always respond in English
- Correct my grammar mistakes gently
- Explain new words with examples
- Use simple English, avoid jargon
```

#### IDENTITY.md —— AI 的名字和风格

```markdown
# 张三的 AI 叫 "Jarvis"
Name: Jarvis
Emoji: 🤖
Style: 管家式助手

# 李四的 AI 叫 "小爪"
Name: 小爪
Emoji: 🦞
Style: 活泼可爱的朋友
```

#### USER.md —— 主人信息

```markdown
# 张三的 USER.md
Name: 张三
Preferred name: 三哥
Profession: 后端工程师
Languages: 中文、英文
Interests: Rust, 分布式系统, 咖啡
```

AI 读了这个文件后，就知道主人是谁、喜好什么，回答会更有针对性。

### 5. 第 4 层：行为规则 —— AI 怎么干活

#### AGENTS.md —— 操作手册

```markdown
# 张三的 AGENTS.md
## 代码规范
- 写 Python 代码用 black 格式化
- 写 TypeScript 用单引号
- commit message 用英文

## 工作习惯
- 每天早上 9 点发一条日报提醒
- 处理文件时先备份
- 执行危险命令前必须确认
```

```markdown
# 李四的 AGENTS.md
## 规则
- 所有回复用中文
- 不要主动执行任何 shell 命令
- 有新消息先总结要点
```

#### TOOLS.md —— 工具使用偏好

```markdown
# 张三的 TOOLS.md
- 搜索优先用 Brave Search
- 截图用浏览器工具
- 发消息用 imsg（我主力用 iMessage）
```

### 6. 第 5 层：技能安装 —— AI 会什么

技能（Skills）是 AI 能做的"特殊本领"：

```
张三安装的技能：
├── 代码审查技能
├── Docker 管理技能
└── Kubernetes 部署技能

李四安装的技能：
├── 日程管理技能
├── 邮件撰写技能
├── 旅行规划技能
└── 翻译技能

王五安装的技能：
├── 股票分析技能
├── Excel 处理技能
└── PDF 解析技能
```

技能来源有三种：
| 来源 | 说明 |
|------|------|
| **内置技能** | 随 OpenClaw 安装就有的基础技能 |
| **ClawHub** | 技能商店，AI 可以自动搜索安装 |
| **自定义技能** | 用户自己写的，放在 `~/.openclaw/workspace/skills/` |

### 7. 第 6 层：插件生态 —— AI 的扩展能力

插件比技能更底层，可以改变 AI 的核心行为：

```json5
// 张三的插件配置
{
  plugins: {
    slots: {
      memory: "long-term-memory",      // 用长期记忆插件
      contextEngine: "lossless-claw"   // 用无损上下文引擎
    },
    entries: {
      "lossless-claw": { enabled: true },
      "long-term-memory": { enabled: true }
    }
  }
}

// 李四的插件配置
{
  plugins: {
    slots: {
      memory: "basic-memory",         // 用基础记忆插件
      contextEngine: "legacy"         // 用默认上下文引擎
    }
  }
}
```

**上下文引擎插件**是特别重要的差异点——它决定了 AI 如何"记住"和"组织"对话历史：

| 引擎 | 策略 | 适合 |
|------|------|------|
| legacy（默认） | 旧消息摘要压缩，保留最近消息 | 一般用户 |
| lossless-claw | 无损上下文，用向量检索 | 需要精确回忆的场景 |
| 自定义引擎 | 任何策略（DAG摘要、向量检索...） | 高级玩家 |

### 8. 第 7 层：记忆积累 —— AI 的"人生经历"不同

**这是最根本的差异。** 即使两个人的配置完全一样，随着使用时间的推移，他们的 AI 也会变得完全不同——因为记忆不同。

```
~/.openclaw/workspace/memory/
├── 2026-01-15.md    # 那天聊了项目架构的问题
├── 2026-01-16.md    # 帮用户修了个 bug
├── 2026-02-01.md    # 用户提到过敏了，AI 记住了
├── 2026-03-01.md    # 讨论了换工作的事
└── ...              # 每天一个文件，持续积累
```

AI 每次启动时会读取最近的记忆文件，所以：
- **张三的 AI** 知道张三喜欢用 Rust、上周做了什么项目、最近在学什么
- **李四的 AI** 知道李四的家人、最近要旅行、关注哪些新闻
- **王五的 AI** 知道王五的投资组合、每天的晨会纪要

### 9. 全对比表：两个人的 OpenClaw 到底哪里不一样

| 维度 | 张三的 OpenClaw | 李四的 OpenClaw |
|------|----------------|----------------|
| **模型** | Claude Sonnet 4.6 | GPT-5.2 |
| **渠道** | WhatsApp + iMessage | Telegram + Slack + Discord |
| **AI 名字** | Jarvis | 小爪 |
| **语气** | 专业、正式、不用 emoji | 活泼、口语化、多emoji |
| **语言** | 中英双语 | 纯中文 |
| **技能** | 代码审查、Docker | 日程管理、旅行规划 |
| **记忆插件** | lossless-claw 无损记忆 | basic-memory 基础记忆 |
| **上下文引擎** | lossless-claw | legacy |
| **安全策略** | sandbox 全开 | 只 pairing |
| **记忆内容** | 三个月的编程讨论 | 两年的生活对话 |
| **工作区技能** | 自写的 K8s 部署脚本 | ClawHub 下载的翻译技能 |

### 10. 类比：OpenClaw 像什么？

```
OpenClaw ≈ 手机操作系统

代码一样      → 都是 iOS / Android
模型选择      → 选什么 CPU / 芯片
渠道配置      → 装了哪些 App
人格设定      → 壁纸、铃声、字体
行为规则      → 系统设置、偏好
技能安装      → 安装的第三方 App
插件生态      → 系统框架扩展（如输入法、桌面插件）
记忆积累      → 相册、聊天记录、文件
```

**两台手机可能是同一个型号、同一个系统版本，但里面的内容、应用、设置完全不同——OpenClaw 也是一样。**

### 11. 一张图总结

```
          openclaw.json（配置文件）
          ┌─────────────────────┐
          │ model: 选什么模型    │
          │ channels: 连什么渠道 │
          │ plugins: 装什么插件  │
          │ session: 会话策略    │
          │ sandbox: 安全策略    │
          └──────────┬──────────┘
                     │
          workspace（工作区文件夹）
          ┌──────────┴──────────┐
          │ SOUL.md    → 人格   │
          │ IDENTITY.md→ 身份   │
          │ USER.md    → 主人   │
          │ AGENTS.md  → 规则   │
          │ TOOLS.md   → 工具   │
          │ skills/    → 技能   │
          │ memory/    → 记忆   │
          └─────────────────────┘
                     │
                     ▼
          每个人的 AI 助手都是独一无二的
```

---

## 一句话总结

**OpenClaw 的代码人人一样，但每个人通过配置文件（选模型、连渠道、设安全）+ 工作区文件（写人格、定规则、积记忆）+ 插件技能（装扩展、装技能），打造出完全不同的个人 AI 助手。用得越久，AI 越懂你——因为记忆在不断积累。**

---

## 相关章节

- [OpenClaw 开源AI助手分析](./OpenClaw开源AI助手分析.md)
- [OpenClaw 中的 Pi Agent 是什么](./OpenClaw中的PiAgent是什么.md)
- [06 - 大语言模型 (LLM) — 6.6 AI Agent](../06-大语言模型LLM/README.md)
