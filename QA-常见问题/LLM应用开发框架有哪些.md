# Q: LLM 应用开发框架有哪些？各自有什么特点？

> **关键词**：LLM 应用开发框架、LangChain、LlamaIndex、LangGraph、CrewAI、AutoGen、DSPy、Semantic Kernel、OpenAI Agents SDK、LiteLLM、Haystack、Vercel AI SDK

---

## 简短回答

LLM 应用开发框架可以按用途分为四大类：**通用编排框架**（LangChain、LlamaIndex、Haystack）、**Agent 框架**（LangGraph、CrewAI、AutoGen、OpenAI Agents SDK）、**模型抽象层**（LiteLLM、Vercel AI SDK、Semantic Kernel）、**Prompt 优化框架**（DSPy）。选哪个取决于你要做什么——简单 RAG 用 LlamaIndex，复杂 Agent 用 LangGraph 或 CrewAI，多模型切换用 LiteLLM，前端集成用 Vercel AI SDK。

---

## 详细解答

### 框架全景图

```
LLM 应用开发框架
├── 通用编排框架（构建各类 LLM 应用）
│   ├── LangChain      ── "瑞士军刀"，功能最全
│   ├── LlamaIndex     ── 专注数据连接与 RAG
│   └── Haystack       ── 企业级 NLP 管道
│
├── Agent 框架（构建自主决策的智能体）
│   ├── LangGraph      ── 图状态机，精细控制 Agent 流程
│   ├── CrewAI          ── 多 Agent 角色协作
│   ├── AutoGen         ── 微软出品，多 Agent 对话
│   └── OpenAI Agents   ── OpenAI 官方，轻量简洁
│
├── 模型抽象与集成层
│   ├── LiteLLM         ── 100+ 模型统一 API
│   ├── Vercel AI SDK   ── 前端/全栈 AI 集成
│   └── Semantic Kernel ── 微软企业级 AI 编排
│
└── Prompt 优化框架
    └── DSPy            ── 用编程代替手写 Prompt
```

---

### 1. 通用编排框架

#### LangChain（132k Star）

LLM 应用开发领域最知名的框架，功能覆盖面最广。

| 维度 | 说明 |
|------|------|
| **开发方** | LangChain AI |
| **语言** | Python / JavaScript |
| **GitHub** | github.com/langchain-ai/langchain |
| **Star** | 132k |
| **定位** | LLM 应用开发的"瑞士军刀" |

**核心能力**：
- **链式调用（Chains）**：将多个 LLM 调用和工具串联成流水线
- **工具集成**：内置数百个第三方工具和 API 连接器
- **记忆管理（Memory）**：支持对话历史、摘要记忆等多种记忆模式
- **RAG 支持**：文档加载、分块、向量化、检索全流程
- **回调系统**：可观测性和调试支持

**代码示例**：
```python
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4o")
prompt = ChatPromptTemplate.from_template("用一句话解释{topic}")
chain = prompt | llm
result = chain.invoke({"topic": "Transformer"})
```

**优势**：生态最大、集成最多、文档丰富、社区活跃
**劣势**：抽象层太多、学习曲线陡、版本变动频繁、简单任务用它过于复杂

---

#### LlamaIndex（48.2k Star）

专注于**数据连接**——把你的私有数据接入 LLM。

| 维度 | 说明 |
|------|------|
| **开发方** | Run-LLama |
| **语言** | Python / TypeScript |
| **GitHub** | github.com/run-llama/llama_index |
| **Star** | 48.2k |
| **定位** | 数据框架，擅长 RAG 和知识问答 |

**核心能力**：
- **数据连接器**：160+ 数据源（PDF、数据库、API、Notion、Slack 等）
- **索引构建**：向量索引、列表索引、树索引、关键词索引等多种策略
- **查询引擎**：自动选择最优检索策略
- **Agent 能力**：也支持基本的 Agent 工具调用

**与 LangChain 对比**：
```
LangChain  = 通用 LLM 应用框架（什么都能做）
LlamaIndex = 数据专家（RAG 和知识检索做到极致）
```

**适合场景**：企业知识库、文档问答、私有数据检索

---

#### Haystack（24.7k Star）

deepset 出品的企业级 NLP/LLM 应用框架。

| 维度 | 说明 |
|------|------|
| **开发方** | deepset |
| **语言** | Python |
| **GitHub** | github.com/deepset-ai/haystack |
| **Star** | 24.7k |
| **定位** | 企业级 NLP 管道，生产就绪 |

**核心能力**：
- **Pipeline 架构**：用有向无环图（DAG）组装组件，灵活可控
- **组件化设计**：检索器、生成器、分类器等可自由组合
- **多后端支持**：Elasticsearch、OpenSearch、FAISS、Weaviate 等
- **评估工具**：内置 RAG 管道评估指标

**适合场景**：企业级搜索系统、生产环境 RAG 管道

---

### 2. Agent 框架

#### LangGraph（28.1k Star）

LangChain 团队推出的 Agent 专用框架，用**图（Graph）和状态机**来精确控制 Agent 流程。

| 维度 | 说明 |
|------|------|
| **开发方** | LangChain AI |
| **语言** | Python / JavaScript |
| **GitHub** | github.com/langchain-ai/langgraph |
| **Star** | 28.1k |
| **定位** | 基于图的 Agent 编排框架 |

**核心能力**：
- **状态图**：用节点（Node）和边（Edge）定义 Agent 的决策流程
- **条件分支**：根据 LLM 输出动态选择下一步
- **持久化**：内置检查点，支持长时间运行和恢复
- **人工介入（Human-in-the-Loop）**：流程中可暂停等待人类确认
- **流式输出**：节点级别的流式返回

**与 LangChain 的关系**：
```
LangChain = 基础积木（模型、工具、Prompt）
LangGraph = 用这些积木搭建复杂 Agent 的框架
```

**适合场景**：需要精细控制流程的复杂 Agent、多步推理、有审批环节的自动化

---

#### CrewAI（47.7k Star）

多 Agent 角色协作框架，让多个 AI "角色"组队完成复杂任务。

| 维度 | 说明 |
|------|------|
| **开发方** | CrewAI Inc |
| **语言** | Python |
| **GitHub** | github.com/crewAIInc/crewAI |
| **Star** | 47.7k |
| **定位** | 多 Agent 角色扮演协作 |

**核心概念**：
- **Agent**：定义角色（如"高级研究员""技术作家"），每个有目标和背景
- **Task**：分配给 Agent 的具体任务
- **Crew**：一组 Agent + 任务的组合，定义协作流程
- **Process**：执行策略（顺序执行 / 层级管理）

**代码示例**：
```python
from crewai import Agent, Task, Crew

researcher = Agent(role="研究员", goal="调研最新 AI 趋势")
writer = Agent(role="作家", goal="将调研结果写成文章")

research_task = Task(description="调研 2025 年 AI Agent 趋势", agent=researcher)
write_task = Task(description="根据调研写一篇分析文章", agent=writer)

crew = Crew(agents=[researcher, writer], tasks=[research_task, write_task])
result = crew.kickoff()
```

**适合场景**：内容生产、调研分析、多步骤工作流

---

#### AutoGen（56.5k Star）

微软研究院出品的多 Agent 对话框架。

| 维度 | 说明 |
|------|------|
| **开发方** | Microsoft |
| **语言** | Python / .NET |
| **GitHub** | github.com/microsoft/autogen |
| **Star** | 56.5k |
| **定位** | 多 Agent 对话与协作 |

**核心能力**：
- **可对话 Agent**：Agent 之间可以自由对话、讨论、辩论
- **代码执行**：内置安全的代码执行环境
- **人类参与**：支持人类作为 Agent 之一参与对话
- **灵活编排**：支持多种对话拓扑（两人对话、群聊、嵌套等）

**适合场景**：复杂推理任务、代码生成与调试、研究探索

---

#### OpenAI Agents SDK（20.5k Star）

OpenAI 官方推出的 Agent 开发框架，简洁轻量。

| 维度 | 说明 |
|------|------|
| **开发方** | OpenAI |
| **语言** | Python |
| **GitHub** | github.com/openai/openai-agents-python |
| **Star** | 20.5k |
| **定位** | OpenAI 官方 Agent 框架，极简设计 |

**核心能力**：
- **Agent 定义**：用简单的 Python 代码定义 Agent 的指令和工具
- **Handoff**：Agent 之间的任务移交
- **Guardrails**：输入/输出安全护栏
- **Tracing**：内置追踪和可观测性

**适合场景**：使用 OpenAI 模型的 Agent 开发、快速原型

---

### 3. 模型抽象与集成层

#### LiteLLM（41.8k Star）

100+ LLM 提供商的统一 API 代理。

| 维度 | 说明 |
|------|------|
| **开发方** | BerriAI |
| **语言** | Python |
| **GitHub** | github.com/BerriAI/litellm |
| **Star** | 41.8k |
| **定位** | LLM API 统一层 + 代理网关 |

**核心能力**：
- **统一 API**：用 OpenAI 格式调用 100+ 模型（Claude、Gemini、Mistral、本地模型等）
- **代理网关**：部署为服务，统一管理 API Key、限流、日志
- **负载均衡**：多模型自动切换和故障转移
- **成本追踪**：记录每次调用的 token 消耗和费用

**代码示例**：
```python
from litellm import completion

# 同一个接口调用不同模型
response = completion(model="gpt-4o", messages=[{"role": "user", "content": "Hello"}])
response = completion(model="claude-sonnet-4-20250514", messages=[{"role": "user", "content": "Hello"}])
response = completion(model="gemini/gemini-pro", messages=[{"role": "user", "content": "Hello"}])
```

**适合场景**：多模型切换、API 网关、成本管理

---

#### Vercel AI SDK（23.1k Star）

面向前端和全栈开发者的 AI 集成工具包。

| 维度 | 说明 |
|------|------|
| **开发方** | Vercel |
| **语言** | TypeScript |
| **GitHub** | github.com/vercel/ai |
| **Star** | 23.1k |
| **定位** | 前端/全栈 AI 应用开发 |

**核心能力**：
- **流式 UI**：在 React/Next.js/Svelte/Vue 中流式展示 AI 回复
- **多模型支持**：OpenAI、Anthropic、Google 等统一接口
- **结构化输出**：类型安全的 JSON 输出
- **工具调用**：前端友好的 Function Calling 支持

**适合场景**：Web AI 应用、聊天界面、AI SaaS 产品

---

#### Semantic Kernel（27.6k Star）

微软出品的企业级 AI 编排 SDK。

| 维度 | 说明 |
|------|------|
| **开发方** | Microsoft |
| **语言** | C# / Python / Java |
| **GitHub** | github.com/microsoft/semantic-kernel |
| **Star** | 27.6k |
| **定位** | 企业级 AI 编排，深度集成微软生态 |

**核心能力**：
- **插件系统**：将传统函数和 AI 能力统一为"插件"
- **规划器**：AI 自动编排多个插件完成复杂任务
- **记忆系统**：嵌入式向量记忆
- **企业集成**：深度集成 Azure OpenAI、Microsoft 365

**适合场景**：.NET/Java 企业级 AI 应用、微软生态用户

---

### 4. Prompt 优化框架

#### DSPy（33.3k Star）

斯坦福出品，用**编程方式**替代手写 Prompt。

| 维度 | 说明 |
|------|------|
| **开发方** | Stanford NLP |
| **语言** | Python |
| **GitHub** | github.com/stanfordnlp/dspy |
| **Star** | 33.3k |
| **定位** | Prompt 自动优化，编程化 LLM 流水线 |

**核心理念**：
- 不手写 Prompt，而是**定义输入输出签名**
- 框架通过**编译器**自动优化 Prompt（类似深度学习的自动微分）
- 支持自动 Few-shot 选择、Chain-of-Thought 注入等

**代码示例**：
```python
import dspy

class QA(dspy.Signature):
    """回答问题"""
    question: str = dspy.InputField()
    answer: str = dspy.OutputField()

qa = dspy.ChainOfThought(QA)
result = qa(question="Transformer 的核心创新是什么？")
```

**适合场景**：需要系统化优化 Prompt 的研究和生产场景

---

### 框架对比总表

| 框架 | Star | 语言 | 定位 | 适合场景 | 学习难度 |
|------|------|------|------|---------|---------|
| **LangChain** | 132k | Python/JS | 通用编排 | 各类 LLM 应用 | 中高 |
| **AutoGen** | 56.5k | Python/.NET | 多 Agent 对话 | 复杂推理、代码生成 | 中 |
| **LlamaIndex** | 48.2k | Python/TS | 数据连接/RAG | 知识库问答、文档检索 | 中 |
| **CrewAI** | 47.7k | Python | 多 Agent 协作 | 内容生产、工作流 | 低 |
| **LiteLLM** | 41.8k | Python | 模型统一 API | 多模型切换、API 网关 | 低 |
| **DSPy** | 33.3k | Python | Prompt 优化 | 系统化 Prompt 工程 | 中高 |
| **LangGraph** | 28.1k | Python/JS | Agent 图编排 | 精细 Agent 控制 | 中高 |
| **Semantic Kernel** | 27.6k | C#/Python/Java | 企业 AI 编排 | 微软生态企业应用 | 中 |
| **Haystack** | 24.7k | Python | 企业 NLP 管道 | 生产级搜索/RAG | 中 |
| **Vercel AI SDK** | 23.1k | TypeScript | 前端 AI 集成 | Web AI 应用 | 低 |
| **OpenAI Agents** | 20.5k | Python | 官方 Agent SDK | OpenAI 模型 Agent | 低 |

> Star 数据来源：GitHub，获取时间 2026 年 4 月

---

### 怎么选？

```
你要做什么？
│
├── 简单的 RAG / 知识问答
│   └── LlamaIndex（最专业）或 Haystack（企业级）
│
├── 通用 LLM 应用（聊天、摘要、翻译等）
│   └── LangChain（生态最大）
│
├── 复杂 Agent（自主规划、工具调用、多步推理）
│   ├── 需要精细流程控制 → LangGraph
│   ├── 多 Agent 协作     → CrewAI 或 AutoGen
│   └── 用 OpenAI 模型    → OpenAI Agents SDK
│
├── 多模型管理 / API 网关
│   └── LiteLLM
│
├── Web / 前端 AI 应用
│   └── Vercel AI SDK
│
├── 微软生态 / .NET
│   └── Semantic Kernel
│
└── 系统化优化 Prompt
    └── DSPy
```

---

### 一句话总结

LLM 应用开发框架百花齐放，**没有"最好的"框架，只有最适合你场景的框架**。入门建议从 LangChain 或 LlamaIndex 开始，Agent 开发看 LangGraph 或 CrewAI，多模型管理用 LiteLLM。

---

## 相关章节

- [06-大语言模型LLM](../06-大语言模型LLM/README.md) — LLM 与 Agent
- [07-AI实践与工具](../07-AI实践与工具/README.md) — 开发框架与工具链
- [LLM 应用开发与 Agent 的区别](./LLM应用开发与Agent的区别.md) — 理解应用层级
- [AI Agent 与 RAG 的关系](./AI-Agent与RAG的关系.md) — Agent 技术栈
- [MCP 协议与使用方式](./MCP协议与使用方式.md) — AI 工具连接标准
