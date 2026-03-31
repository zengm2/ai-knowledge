# Q: MCP 是什么，这个协议怎么使用？

> **关键词**：MCP、Model Context Protocol、模型上下文协议、AI 工具连接、MCP Server、MCP Client、JSON-RPC、Function Calling

**简短回答**：MCP（Model Context Protocol）是 Anthropic 提出的开放协议，统一了 AI 应用连接外部工具和数据源的方式，相当于"AI 的 USB 接口"。用户只需配置 Server 地址即可使用；开发者可以用 SDK 快速开发自己的 MCP Server。

---

## 详细解答

### 为什么需要 MCP？

没有 MCP 时，M 个 AI 应用连 N 个工具需要 M×N 种适配。有了 MCP，统一协议后只需 M+N 种适配。

```
AI 应用 A ──┐                ┌── GitHub MCP Server
AI 应用 B ──┼── MCP 协议 ──┼── Slack MCP Server
AI 应用 C ──┘                ├── 数据库 MCP Server
                              └── 日历 MCP Server
```

### 架构：三个核心角色

| 角色 | 是什么 | 举例 |
|------|-------|------|
| **MCP Host** | 运行 AI 模型的应用 | Claude Desktop、Devin、Cursor |
| **MCP Client** | Host 内部的连接模块 | 通常内置在 Host 中 |
| **MCP Server** | 提供工具和数据的服务端 | GitHub Server、Slack Server 等 |

### MCP Server 提供三种能力

| 能力 | 说明 | 举例 |
|------|------|------|
| **Tools** | AI 可调用的函数 | 创建 Issue、发消息 |
| **Resources** | AI 可读取的数据 | 文件内容、数据库记录 |
| **Prompts** | 预定义提示模板 | 代码审查模板 |

### 使用方式

#### 1. 用户：配置现成的 MCP Server

以 Claude Desktop 为例，编辑配置文件：

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxx"
      }
    }
  }
}
```

重启后 AI 就能直接操作 GitHub。

#### 2. 开发者：写一个 MCP Server

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("我的工具")

@mcp.tool()
def query_employee(name: str) -> str:
    """根据姓名查询员工信息"""
    result = db.query(f"SELECT * FROM employees WHERE name = '{name}'")
    return str(result)

@mcp.resource("company://handbook")
def get_handbook() -> str:
    """获取公司员工手册"""
    with open("handbook.md") as f:
        return f.read()

mcp.run()
```

### 通信协议

底层使用 JSON-RPC 2.0，两种传输方式：

| 传输方式 | 说明 | 适合场景 |
|---------|------|---------|
| **stdio** | 标准输入输出 | 本地 Server，最常用 |
| **SSE** | HTTP 通信 | 远程 Server |

### 已有的 MCP Server 生态

| 类别 | Server | 功能 |
|------|--------|------|
| **开发** | GitHub、GitLab | 管理仓库、Issue、PR |
| **通讯** | Slack、Discord | 消息读写 |
| **项目管理** | Linear、Jira | 任务管理 |
| **数据库** | PostgreSQL、SQLite | 数据操作 |
| **搜索** | Brave Search | 联网搜索 |
| **浏览器** | Puppeteer | 浏览器自动化 |

### MCP vs Function Calling

| 对比 | Function Calling | MCP |
|------|-----------------|-----|
| **标准化** | 各家格式不同 | 统一开放协议 |
| **可复用** | 绑定特定应用 | 一次开发到处用 |
| **安全** | 数据过第三方 | stdio 下数据不出本机 |

### 一句话总结

MCP 定义了 AI 应用和工具服务之间的统一通信方式，让生态中的工具可以互通共享，是 AI Agent 连接外部世界的标准化基础设施。

---

## 相关章节

- [06-大语言模型LLM](../06-大语言模型LLM/README.md) — Agent 与工具调用
- [07-AI实践与工具](../07-AI实践与工具/README.md) — AI 工程实践
- [AI Agent 与 RAG 的关系](./AI Agent与RAG的关系.md) — Agent 架构
