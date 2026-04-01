# AI 知识教学整理

> 一份系统化的人工智能学习指南，从基础概念到前沿技术，帮助你建立完整的 AI 知识体系。

---

## 大纲目录

| 章节 | 主题 | 状态 | 说明 |
|------|------|------|------|
| [01](./01-AI基础概念/README.md) | AI 基础概念 | :white_check_mark: 已完成 | AI 的定义、历史、分类与核心思想 |
| [02](./02-机器学习基础/README.md) | 机器学习基础 | :white_check_mark: 已完成 | 监督/无监督/强化学习，经典算法 |
| [03](./03-深度学习基础/README.md) | 深度学习基础 | :white_check_mark: 已完成 | 神经网络、CNN、RNN、Transformer |
| [04](./04-自然语言处理NLP/README.md) | 自然语言处理 (NLP) | :white_check_mark: 已完成 | 文本处理、词嵌入、序列模型、预训练模型 |
| [05](./05-计算机视觉CV/README.md) | 计算机视觉 (CV) | :white_check_mark: 已完成 | 图像分类、目标检测、图像生成 |
| [06](./06-大语言模型LLM/README.md) | 大语言模型 (LLM) | :white_check_mark: 已完成 | GPT、BERT、提示工程、RAG、Agent |
| [07](./07-AI实践与工具/README.md) | AI 实践与工具 | :white_check_mark: 已完成 | 框架、部署、MLOps、数据工程 |
| [08](./08-AI伦理与未来/README.md) | AI 伦理与未来 | :white_check_mark: 已完成 | 偏见、安全、法规、AGI 展望 |

---

## 学习路线建议

```
AI 基础概念 (01)
    |
    v
机器学习基础 (02) ──────> 深度学习基础 (03)
                              |
                    +---------+---------+
                    |                   |
                    v                   v
              NLP (04)             CV (05)
                    |                   |
                    +---------+---------+
                              |
                              v
                      大语言模型 (06)
                              |
                              v
                     AI 实践与工具 (07)
                              |
                              v
                    AI 伦理与未来 (08)
```

## QA 常见问题

学习过程中的问答记录，每个问题独立成文档：

| # | 问题 | 关键词 |
|---|------|--------|
| 1 | [机器学习规则如何形成模型](./QA-常见问题/机器学习规则如何形成模型.md) | 机器学习、模型形成、CNN、传统ML vs 深度学习 |
| 2 | [机器学习程序如何输出模型](./QA-常见问题/机器学习程序如何输出模型.md) | 模型输出、参数保存、训练过程、模型文件 |
| 3 | [大模型与传统模型的区别](./QA-常见问题/大模型与传统模型的区别.md) | 大语言模型、Transformer、预训练、涌现能力、RLHF |
| 4 | [OpenClaw 开源AI助手分析](./QA-常见问题/OpenClaw开源AI助手分析.md) | OpenClaw、架构设计、代码结构、Gateway、WebSocket协议、Agent Loop、插件系统 |
| 5 | [OpenClaw 中的 Pi Agent 是什么](./QA-常见问题/OpenClaw中的PiAgent是什么.md) | Pi Agent、pi-mono、pi-agent-core、pi-ai、Agent 运行时、LLM API、工具调用 |
| 6 | [不同人的 OpenClaw 差异在哪里](./QA-常见问题/OpenClaw不同人的差异在哪里.md) | 个性化、配置定制、SOUL.md、Skills、插件、模型选择、记忆系统、工作区 |
| 7 | [模型训练后如何运行推理](./QA-常见问题/模型训练后如何运行推理.md) | 模型推理、Inference、前向传播、Tokenizer、自回归生成、采样策略、推理框架 |
| 8 | [幂律关系与 Scaling Laws](./QA-常见问题/幂律关系与ScalingLaws.md) | 幂律关系、Power Law、Scaling Laws、收益递减、帕累托法则、大模型规模定律 |
| 9 | [提示工程与提示词的区别](./QA-常见问题/提示工程与提示词的区别.md) | 提示工程、Prompt Engineering、提示词、Prompt、System Prompt、Few-shot、Chain-of-Thought |
| 10 | [检索增强生成 RAG](./QA-常见问题/检索增强生成RAG.md) | RAG、检索增强生成、向量检索、Embedding、知识库问答、幻觉 |
| 11 | [AI Agent 与 RAG 的关系](./QA-常见问题/AI-Agent与RAG的关系.md) | AI Agent、RAG、ChatGPT、Claude Code、工具调用、向量检索、代码搜索、Agent 架构 |
| 12 | [向量数据库原理与工作方式](./QA-常见问题/向量数据库原理与工作方式.md) | 向量数据库、Vector Database、Embedding、相似度搜索、ANN、HNSW、余弦相似度 |
| 13 | [MCP 协议与使用方式](./QA-常见问题/MCP协议与使用方式.md) | MCP、Model Context Protocol、AI 工具连接、MCP Server、JSON-RPC、Function Calling |
| 14 | [Manus Agent 分析](./QA-常见问题/Manus-Agent分析.md) | Manus、AI Agent、虚拟计算机、多 Agent 协作、任务执行、交付物导向、浏览器自动化 |
| 15 | [Manus 与 OpenClaw 对比](./QA-常见问题/Manus与OpenClaw对比.md) | Manus、OpenClaw、云端 vs 本地、任务执行 vs 私人助手、全渠道、个性化、开源 |
| 16 | [Devin AI 软件工程师分析](./QA-常见问题/Devin-AI软件工程师分析.md) | Devin、Cognition、AI 软件工程师、终端 Agent、subagent、MCP、Claude |
| 17 | [Devin 与 Windsurf 的关系](./QA-常见问题/Devin与Windsurf的关系.md) | Devin、Windsurf、Cognition、Codeium、收购、AI 编辑器 vs AI Agent、OpenAI |
| 18 | [Caffe 框架与 AI 使用场景](./QA-常见问题/Caffe框架与AI使用场景.md) | Caffe、贾扬清、深度学习框架、计算机视觉、CNN、PyTorch、框架演变 |
| 19 | [LLM 应用开发与 Agent 的区别](./QA-常见问题/LLM应用开发与Agent的区别.md) | LLM 应用开发、AI Agent、工具调用、自主决策、行动循环、复杂度光谱 |

---

## 适合人群

- 对 AI 感兴趣的初学者
- 希望系统化学习 AI 的开发者
- 准备转型 AI 领域的技术人员

## 前置知识

- 基础编程能力（推荐 Python）
- 高中及以上数学基础（线性代数、概率统计、微积分有帮助但非必须）

---

*本教学整理持续更新中，每次新增内容后大纲会同步更新。*
