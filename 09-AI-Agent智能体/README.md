# 09 - AI Agent 智能体

> AI Agent 是 2024-2025 年最热门的 AI 应用方向——它让大语言模型从"会聊天"进化为"会做事"。如果说 LLM 是一个知识渊博的大脑，那 Agent 就是给这个大脑装上了眼睛、双手和记忆力，让它能够感知环境、制定计划、使用工具并自主完成复杂任务。本章系统介绍 AI Agent 的核心概念、架构设计、关键技术和典型应用。

---

## 9.1 什么是 AI Agent

### 9.1.1 定义与核心特征

AI Agent（智能体）是指**以大语言模型为核心推理引擎，具备自主感知、规划、决策和行动能力的智能系统**。与简单的聊天机器人不同，Agent 能够理解用户目标，将复杂任务分解为可执行的步骤，调用外部工具完成操作，并根据执行结果动态调整策略。

用一个类比来理解：普通的 LLM 像是一个坐在书桌前的**顾问**——你问他问题，他给出回答，但他不会帮你动手做事。而 Agent 更像是一个**实习生**——你给他一个目标，他会自己思考怎么做、去查资料、用各种工具、遇到问题自我调整，最终把成果交付给你。

Agent 的核心公式：**Agent = LLM（大脑）+ Planning（规划）+ Tools（工具）+ Memory（记忆）**

| 特征 | 说明 | 举例 |
|------|------|------|
| **自主性（Autonomy）** | 无需人类逐步指挥，能自主决定下一步行动 | 自动判断需要先搜索还是先读文件 |
| **反应性（Reactivity）** | 能感知环境变化并做出响应 | 发现代码报错后自动修复 |
| **推理性（Reasoning）** | 基于 LLM 进行逻辑推理和计划制定 | 将"做一个网站"分解为多个子任务 |
| **工具使用（Tool Use）** | 能调用外部工具扩展自身能力 | 搜索网页、执行代码、操作文件 |

### 9.1.2 Agent 与传统 LLM 应用的区别

从简单到复杂，LLM 应用可以排列成一个**复杂度光谱**：

| 维度 | 普通聊天机器人 | RAG 应用 | AI Agent |
|------|---------------|---------|----------|
| **交互模式** | 一问一答 | 检索后回答 | 自主规划、多步执行 |
| **知识来源** | 仅模型内部知识 | 模型 + 外部知识库 | 模型 + 知识库 + 实时工具 |
| **是否调用工具** | 否 | 通常仅检索 | 是，可调用多种工具 |
| **执行能力** | 仅生成文本 | 仅生成文本 | 可执行操作（写文件、发请求等） |
| **自主决策** | 无 | 无 | 有，能自主决定行动路径 |
| **典型轮次** | 1 轮 | 1-2 轮 | 5-50+ 轮内部循环 |

关键区别在于：**传统 LLM 应用的流程是开发者预先定义好的（确定性的），而 Agent 的执行路径是由 LLM 在运行时动态决定的（非确定性的）**。

### 9.1.3 Agent 的能力层次

业界通常将 Agent 的能力分为五个递进层次：

```
L5 ── 多智能体协作 ──── 多个专业 Agent 协同完成复杂项目
L4 ── 自主执行 ────── Agent 自主完成端到端任务，极少需要人工干预
L3 ── 多步规划 ────── 能分解复杂任务，按计划逐步执行
L2 ── 工具调用 ────── 能调用外部工具（搜索、计算、API）
L1 ── 对话交互 ────── 基础的自然语言理解与生成
```

| 层次 | 能力描述 | 典型产品举例 |
|------|---------|-------------|
| L1 | 基础对话，一问一答 | ChatGPT 基础对话、智能客服 |
| L2 | 能调用搜索、计算器等单一工具 | ChatGPT with Browsing、Perplexity |
| L3 | 能分解任务、多步规划并执行 | Claude with Artifacts、Code Interpreter |
| L4 | 自主完成端到端复杂任务 | Devin、Claude Code、Manus |
| L5 | 多个 Agent 分工协作 | MetaGPT 虚拟软件公司、多 Agent 研究系统 |

当前（2025 年中），主流产品大多处于 L3-L4 水平，L5 仍主要停留在研究和早期实验阶段。

---

## 9.2 Agent 核心架构

### 9.2.1 感知-推理-行动循环

Agent 的运行可以用一个核心循环来概括——**感知 → 推理 → 行动 → 观察**，如此反复直到任务完成：

```
              ┌─────── 感知 (Perception) ◄──────┐
              │        接收信息和反馈             │
              ▼                                  │
       推理 (Reasoning)                          │
        - 理解当前状态                            │
        - 分析可用工具                            │
        - 制定/调整计划                           │
              ▼                                  │
       行动 (Action)                             │
        - 调用工具 / 执行代码 / 读写文件          │
              ▼                                  │
       观察 (Observation) ──────────────────────┘
        - 获取执行结果
        - 检查是否完成
```

这个循环被称为 **Agent Loop（智能体循环）**，是所有 Agent 系统的核心。每一轮循环中，LLM 根据历史信息和当前观察结果决定下一步行动。当 LLM 判断任务已完成时，循环结束。

### 9.2.2 ReAct 框架

**ReAct（Reasoning + Acting）** 是 Yao et al.（2022）提出的经典 Agent 框架，让 LLM 交替进行**推理（Thought）**、**行动（Action）** 并获取**观察结果（Observation）**。

以"帮我查一下北京今天的天气，并推荐合适的穿搭"为例：

```
Thought 1: 用户想知道北京今天的天气和穿搭推荐。我需要先查询天气信息。
Action 1:  search("北京今天天气")
Observation 1: 北京今天晴，气温 12-24°C，西北风 3-4 级，紫外线较强。

Thought 2: 天气晴、温差大（12-24°C）、有风。可以基于这些信息给出穿搭建议。
Action 2:  finish(回复用户)

最终回复: 北京今天晴好，12-24°C，早晚温差大。建议轻薄外套+长袖内搭，
         带墨镜防晒。
```

ReAct 的优势在于推理过程**透明可解释**——你可以清楚地看到 Agent 每一步"想了什么"和"做了什么"，这对调试和建立用户信任非常重要。

### 9.2.3 规划能力（Planning）

规划是 Agent 区别于简单工具调用的关键能力。常见的规划策略包括：

**1. 顺序规划（Sequential Planning）** —— 将任务分解为线性步骤序列：

```
任务：写一篇关于量子计算的技术博客
Step 1: 搜索量子计算最新进展 → Step 2: 拟定文章大纲
Step 3: 撰写各章节内容 → Step 4: 润色并添加参考文献
```

**2. DAG 规划（有向无环图）** —— 识别可并行执行的子任务：

```
        ┌── 调研竞品 A ──┐
启动 ───┼── 调研竞品 B ──┼──► 汇总对比 ──► 生成报告
        └── 调研竞品 C ──┘
```

**3. 自适应规划（Adaptive Planning）** —— 不预先制定完整计划，每一步执行后根据结果动态调整后续步骤。这种策略更灵活，适合结果不可预测的任务。大多数现代 Agent 采用这种方式。

### 9.2.4 记忆系统（Memory）

Agent 的记忆系统分为多个层次：

| 记忆类型 | 对应人类记忆 | 实现方式 | 特点 |
|---------|------------|---------|------|
| **短期记忆** | 工作记忆 | 对话上下文窗口 | 容量有限（受 context window 限制），当前会话有效 |
| **长期记忆** | 长期记忆 | 向量数据库、文件存储 | 持久化存储，跨会话保留 |
| **工作记忆** | 便签/草稿纸 | Scratchpad、中间状态 | 当前任务的临时推理空间 |

即使现代 LLM 的上下文窗口已扩展到 128K-200K tokens，在长时间运行的复杂任务中仍可能溢出。应对策略包括：**对话摘要**（定期压缩历史对话）、**关键信息提取**（只保留相关信息）、**外部存储**（写入文件或数据库，需要时再读取）。

长期记忆使 Agent 能够跨会话积累经验。例如编程 Agent 可以记住用户偏好的代码风格、项目架构约定，从而在后续任务中表现更好。

### 9.2.5 反思与自我纠正（Reflection）

优秀的 Agent 不仅能执行任务，还能**审视自己的行为并从错误中学习**。**Reflexion 框架**（Shinn et al., 2023）是典型实现：

```
执行任务 → 获取反馈 → 反思失败原因 → 将反思写入记忆 → 重新尝试
```

例如 Agent 在写代码时：第 1 次尝试运行测试失败 → 反思"我忽略了空数组的边界情况" → 将反思存入记忆 → 第 2 次尝试考虑边界情况，测试全部通过。

自我纠正的关键要素：**错误检测**（通过测试失败、API 报错等）、**原因分析**（LLM 推理）、**策略调整**、**循环限制**（设定最大重试次数防止无限循环）。

---

## 9.3 工具调用（Tool Use）

工具调用是 Agent 从"思考者"变为"行动者"的关键——如果说 LLM 是大脑，工具就是 Agent 的双手。

### 9.3.1 Function Calling

Function Calling 是目前最主流的工具调用方式。开发者预先定义可用工具的 JSON Schema，LLM 在需要时生成结构化的调用请求：

```python
# 定义工具 schema
tools = [{
    "type": "function",
    "function": {
        "name": "get_weather",
        "description": "查询指定城市的当前天气",
        "parameters": {
            "type": "object",
            "properties": {
                "city": {"type": "string", "description": "城市名称"}
            },
            "required": ["city"]
        }
    }
}]

# LLM 不直接执行函数，而是返回调用意图:
# {"function": {"name": "get_weather", "arguments": "{\"city\": \"北京\"}"}}
# 实际执行由应用程序完成 —— 这保证了安全性和可控性
```

### 9.3.2 MCP 协议（Model Context Protocol）

**MCP（Model Context Protocol）** 是 Anthropic 于 2024 年 11 月推出的开放标准协议，为 AI 模型与外部工具/数据源之间建立**统一的连接标准**。

可以把 MCP 理解为 **AI 世界的 USB 接口**——之前每个 AI 应用需要为每个工具单独开发连接器（M×N 个），有了 MCP，工具方只需实现一个 MCP Server，AI 应用只需实现一个 MCP Client，即插即用。

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   MCP Host   │───▶│  MCP Client  │───▶│  MCP Server  │
│  (如 Claude)  │    │  (协议客户端) │    │  (如 GitHub)  │
└──────────────┘    └──────────────┘    └──────────────┘
```

MCP 提供四种核心能力：

| 能力 | 说明 | 示例 |
|------|------|------|
| **Resources** | 向模型暴露数据（类似 GET） | 读取文件、获取数据库记录 |
| **Tools** | 让模型执行操作（类似 POST） | 发送邮件、创建 GitHub Issue |
| **Prompts** | 预定义提示模板和工作流 | 代码审查模板、翻译流程 |
| **Sampling** | Server 反向请求 LLM 生成内容 | 工具需要 AI 辅助决策 |

**MCP 与 Function Calling 的对比：**

| 维度 | Function Calling | MCP |
|------|-----------------|-----|
| 定位 | API 级别的调用约定 | 应用级别的连接协议 |
| 标准化 | 各厂商各不相同 | 统一开放标准 |
| 发现机制 | 开发者手动定义 | 动态发现可用工具 |
| 生态复用 | 每个应用单独实现 | 一个 Server 可被多个 Host 共用 |

截至 2025 年中，Claude Desktop、Cursor、Windsurf、Devin、OpenAI Agents SDK 等主流产品均已支持 MCP。

### 9.3.3 常见工具类型

| 工具类别 | 具体工具 | 用途 |
|---------|---------|------|
| **搜索** | Google Search、Bing、Perplexity | 获取实时信息 |
| **代码执行** | Python 解释器、Node.js、Shell | 运行代码、数据处理 |
| **文件操作** | 读/写/编辑文件、目录管理 | 创建和修改文档、代码 |
| **浏览器** | Playwright、Puppeteer、Browser Use | 网页浏览、信息抓取 |
| **数据库** | SQL 查询、向量数据库检索 | 数据查询和存储 |
| **API 调用** | REST API、GraphQL | 与第三方服务交互 |
| **通信** | 发送邮件、Slack 消息 | 通知和协作 |
| **多媒体** | 图片生成、语音合成、OCR | 处理非文本内容 |

> 💡 工具的选择直接决定了 Agent 的能力边界。一个只有搜索工具的 Agent 只能查资料，而同时具备搜索、代码执行和文件操作能力的 Agent 则可以完成端到端的开发任务。

---

## 9.4 多智能体系统（Multi-Agent）

### 9.4.1 为什么需要多 Agent

单个 Agent 面对真正复杂的任务时会遇到瓶颈：

- **上下文窗口限制**：单个 Agent 需要在一个上下文中维护所有信息，容易溢出
- **角色混淆**：既当产品经理又当程序员又当测试，容易在角色切换中出错
- **专业化不足**：一个 Prompt 很难让 LLM 同时在多个领域都表现出色
- **容错性差**：单个 Agent 出错可能导致整个任务失败

多 Agent 系统通过**分工协作**来解决这些问题，就像公司让不同岗位的人各司其职。

### 9.4.2 协作模式

**1. 角色扮演（Role-based）** —— 为每个 Agent 分配明确角色：

```
项目经理 Agent ──► 分解任务、分配工作、跟踪进度
架构师 Agent   ──► 设计系统架构、技术选型
程序员 Agent   ──► 编写代码实现功能
测试员 Agent   ──► 编写测试、发现 Bug
```

**2. 辩论/讨论（Debate）** —— 多个 Agent 从不同角度讨论同一问题，通过观点碰撞得出更好结论。

**3. 层级式（Hierarchical）** —— 一个"主管" Agent 负责任务分配和质量控制，下属 Agent 执行具体任务。

**4. 流水线（Pipeline）** —— Agent 按顺序处理，每个 Agent 的输出成为下一个的输入，类似工厂流水线。

### 9.4.3 主流框架

| 框架 | 开发者 | 核心理念 | 适用场景 | 特点 |
|------|--------|---------|---------|------|
| **CrewAI** | CrewAI 团队 | 角色扮演协作 | 内容创作、研究分析 | 简单易用，角色定义直观 |
| **AutoGen** | 微软 | 多 Agent 对话 | 研究探索、复杂推理 | 灵活的对话模式，支持人机协作 |
| **LangGraph** | LangChain | 图状态机 | 复杂工作流 | 精确的流程控制，适合生产环境 |
| **MetaGPT** | DeepWisdom | 虚拟软件公司 | 软件开发 | 模拟真实研发流程，标准化产出 |
| **OpenAI Agents SDK** | OpenAI | 轻量化 Agent | 通用 Agent 应用 | 官方支持，集成 OpenAI 生态 |

> 💡 选择建议：快速原型用 CrewAI；精确流程控制用 LangGraph；生产级应用需根据具体需求评估。

---

## 9.5 Agent 开发实践

### 9.5.1 构建第一个 Agent

下面用 OpenAI Function Calling 构建一个简单的 Agent，展示核心的 Agent Loop 模式：

```python
import openai, json
client = openai.OpenAI()

# 定义工具和实现
tools = [{"type": "function", "function": {
    "name": "get_weather",
    "description": "查询指定城市天气",
    "parameters": {"type": "object",
        "properties": {"city": {"type": "string"}},
        "required": ["city"]}
}}]

def get_weather(city):
    return f"{city}：晴，22°C，西风 2 级"

tool_map = {"get_weather": get_weather}

# Agent 主循环
def run_agent(user_message):
    messages = [
        {"role": "system", "content": "你是一个有用的助手。"},
        {"role": "user", "content": user_message}
    ]
    while True:  # Agent Loop
        response = client.chat.completions.create(
            model="gpt-4o", messages=messages, tools=tools
        )
        msg = response.choices[0].message
        if not msg.tool_calls:        # LLM 决定直接回复，结束循环
            return msg.content
        messages.append(msg)           # 执行 LLM 请求的工具调用
        for tc in msg.tool_calls:
            result = tool_map[tc.function.name](
                **json.loads(tc.function.arguments))
            messages.append({"role": "tool",
                "tool_call_id": tc.id, "content": result})
        # 循环继续，LLM 根据工具结果决定下一步
```

核心模式：**循环调用 LLM → LLM 决定调用工具 → 执行工具 → 将结果返回 LLM → LLM 决定继续还是输出最终回复**。

### 9.5.2 Agent 设计模式

**1. 路由模式（Router Pattern）** —— 一个路由 Agent 判断意图，分发给专门的子 Agent：

```
用户请求 ──► 路由 Agent ──┬──► 编程 Agent（"帮我写代码"）
                          ├──► 搜索 Agent（"帮我查资料"）
                          └──► 写作 Agent（"帮我写文章"）
```

**2. RAG + Agent 模式** —— 将向量检索集成到 Agent 工具集中，Agent 在需要时主动检索知识库。

**3. 监督者模式（Supervisor）** —— 主管 Agent 负责任务编排和质量控制，可审查工作 Agent 的输出，不满意时要求重做。

**4. Human-in-the-Loop（人机协作）** —— 在关键决策节点引入人类审批，确保 Agent 不执行高风险操作。这是目前生产环境中最推荐的模式。

### 9.5.3 常见挑战与解决方案

| 挑战 | 表现 | 解决方案 |
|------|------|---------|
| **行动幻觉** | Agent 调用不存在的工具或传错参数 | 严格的工具 schema 校验；清晰的工具描述 |
| **无限循环** | 反复执行相同操作，无法收敛 | 设置最大循环次数；检测重复行为 |
| **成本失控** | 复杂任务消耗大量 token | 设置 token 预算上限；小模型处理简单子任务 |
| **安全风险** | 可能执行危险操作（如删除文件） | 沙箱执行环境；敏感操作需人类确认 |
| **评估困难** | 行为非确定性，难以传统测试 | 多场景测试集；评估最终结果而非中间步骤 |
| **上下文溢出** | 长任务上下文超出窗口 | 对话摘要；关键信息外部存储 |

> ⚠️ 安全性提示：永远不要让 Agent 在没有沙箱的环境中直接执行用户输入的代码，也不要给 Agent 生产数据库的写入权限而没有审批机制。Agent 的自主性是双刃剑——能力越大，风险越大。

---

## 9.6 典型 Agent 产品分析

### 9.6.1 编程 Agent

编程是 Agent 最成熟的应用领域之一——代码可以运行、测试有明确对错，为 Agent 提供了清晰的反馈信号。

| 产品 | 开发者 | 定位 | 核心特点 |
|------|--------|------|---------|
| **Devin** | Cognition | 自主 AI 软件工程师 | 完整开发环境（终端、浏览器、编辑器），端到端开发，异步协作 |
| **Claude Code** | Anthropic | 终端编程 Agent | 命令行原生，深度理解代码库，强大的搜索和编辑能力 |
| **Cursor** | Anysphere | AI 代码编辑器 | 基于 VS Code，Tab 补全 + Agent 模式 |
| **GitHub Copilot** | GitHub/Microsoft | AI 编程助手 | 编辑器插件，Agent 可执行多步修改和 PR 创建 |
| **Windsurf** | Cognition | AI IDE | Cascade 功能提供类 Agent 的多步操作 |

编程 Agent 的典型工作流：接收任务 → 理解代码库 → 定位相关文件 → 编写/修改代码 → 运行测试 → 修复问题 → 提交结果。

### 9.6.2 通用 Agent

通用 Agent 试图处理更广泛的任务类型，不局限于某个垂直领域：

- **Manus**（2025 年初）：在云端虚拟机运行，可操作浏览器、执行代码、管理文件，任务完成后将成果作为"交付物"呈现。典型场景：市场调研、数据分析、旅行规划。
- **OpenAI Operator**：能操控浏览器的 Agent，代替用户在网页上完成预订、购物等操作。
- **Computer Use Agent**：直接看屏幕截图，通过模拟鼠标键盘控制计算机。Anthropic 的 Claude Computer Use 是代表。

### 9.6.3 企业 Agent

企业场景注重稳定性、安全性和可控性：

- **智能客服 Agent**：理解问题 → 查询知识库和订单系统 → 自动回复或升级人工。比传统客服机器人能处理更复杂的多轮对话和跨系统操作。
- **数据分析 Agent**：自然语言查询 → 生成 SQL → 查询数据库 → 生成图表和报告。让非技术人员也能做数据分析。
- **流程自动化 Agent**：连接 CRM、ERP、邮件等系统，自动完成跨系统业务流程。

---

## 9.7 Agent 的未来趋势

**Agent as OS（Agent 即操作系统）** —— 未来的操作系统可能以 Agent 为核心，用自然语言替代图标和窗口。你告诉 Agent 想做什么，它自动调度各种能力完成。Apple Intelligence、Windows Copilot 已初露端倪。

**Agent-to-Agent 通信（A2A）** —— Google 在 2025 年提出的 A2A 协议，让不同厂商的 Agent 能发现彼此、交换信息、协调任务，类似互联网的 HTTP 协议为 Agent 互联互通建立基础。

**自我进化 Agent** —— 当前 Agent 部署后能力固定。未来的 Agent 将从每次任务中学习，持续改进策略和能力，需要解决持续学习、经验蒸馏等技术难题。

**具身 Agent（Embodied Agents）** —— 将 Agent 智能与物理机器人结合，让 AI 在现实世界行动。想象一个能理解"帮我把客厅收拾一下"的家务机器人——需要视觉感知、运动规划、物体操作等多种能力协同。

**安全与对齐挑战** —— 随着 Agent 能力增强，关键问题愈发紧迫：权限控制（Agent 该有多大权限？）、意图对齐（行为是否符合用户真实意图？）、可解释性（错误决策能否被理解？）、滥用防护（防止恶意用途）。这些需要技术、政策和社会层面的共同努力。

---

## 9.8 学习建议与延伸阅读

### 推荐论文

| 论文 | 年份 | 要点 |
|------|------|------|
| ReAct: Synergizing Reasoning and Acting in LMs | 2022 | Agent 经典框架，Thought-Action-Observation 范式 |
| Reflexion: Language Agents with Verbal RL | 2023 | Agent 自我反思和纠错机制 |
| Toolformer: LMs Can Teach Themselves to Use Tools | 2023 | LLM 自主学习使用工具 |
| The Landscape of Emerging AI Agent Architectures | 2024 | Agent 架构综述 |
| A Survey on LLM based Autonomous Agents | 2023 | LLM Agent 最全面的综述之一 |

### 推荐学习资源

- **LangChain / LangGraph 文档**（docs.langchain.com）：LLM 应用和 Agent 工作流开发参考
- **OpenAI Agents SDK 文档**：官方推荐的 Agent 构建方式
- **Anthropic MCP 文档**（modelcontextprotocol.io）：MCP 协议规范和开发指南
- **Lilian Weng 博客**（lilianweng.github.io）：《LLM Powered Autonomous Agents》是该领域最好的技术博客之一

### 动手实践建议

1. **入门**：用 OpenAI Function Calling 构建一个能搜索和计算的简单 Agent
2. **进阶**：用 LangGraph 构建带状态管理和错误恢复的 Agent 工作流
3. **实战**：为日常工作构建自动化 Agent（邮件摘要、代码审查、报告生成）
4. **探索**：用 CrewAI 或 AutoGen 搭建多 Agent 系统，体验 Agent 协作

### 推荐开源项目

| 项目 | 说明 |
|------|------|
| **LangGraph** | LangChain 的 Agent 编排框架，图状态机模式 |
| **CrewAI** | 多 Agent 角色扮演协作框架 |
| **AutoGen** | 微软开源的多 Agent 对话框架 |
| **MetaGPT** | 模拟软件公司的多 Agent 框架 |
| **Browser Use** | 让 Agent 控制浏览器的开源工具 |
| **OpenAI Agents SDK** | OpenAI 官方 Agent 开发 SDK |

---

*上一章：[08 - AI 伦理与未来](../08-AI伦理与未来/README.md)* | *下一章：[10 - 多模态 AI](../10-多模态AI/README.md)*
