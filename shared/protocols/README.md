# Multi-Agent 协作协议层

`shared/protocols/` 定义跨 harness 复用的协作协议。

它位于全局规范（`shared/AGENTS.md`）与具体 Agent 角色定义（`agents/`）之间，解决的不是“某个 Agent 应该是什么角色”，而是“多个角色如何围绕一个任务协同工作”。

## 1. 分层定位

```text
AGENTS.md
  ↓
组织级原则 / 权责边界 / 通用工程纪律

protocols/
  ↓
任务契约 / 状态转换 / 交付证据 / Review Gate

agents/
  ↓
Architect / Investigator / Programmer 的角色职责

harness/
  ↓
OpenCode / Codex 等平台适配
```

规则归属原则：

- “所有任务都必须遵守”的原则放 `AGENTS.md`；
- “一次协作如何运行”的机制放 `protocols/`；
- “某个角色如何行动”的规则放 `agents/`；
- “某个平台怎么配置”的内容放 `harness/`。

不要在多个层重复定义同一规则。

## 2. 当前协议

### `task-contract.md`

定义 Architect 委派任务时的最小契约，包括 Goal、Context、Constraints、Scope、Evidence、Artifact、Completion Criteria 等。

目标是减少隐式上下文和自然语言委派中的歧义。

### `iteration-protocol.md`

定义一次标准软件工程迭代如何从需求进入调查、决策、实现、验证、Review，再进入完成或返工。

它是默认协议，不要求所有简单任务都机械走完整流程。

### `review-gate.md`

定义什么情况下可以给出 PASS / NEEDS_CHANGES / BLOCKED，以及 Review 必须基于哪些证据。

目标是把“感觉已经完成”变成“有证据地完成”。

## 3. 使用方式

Architect / Primary Agent 根据任务复杂度选择协议。

简单、局部、低风险任务可以压缩流程；复杂、跨模块、高风险或架构性任务应显式使用完整 Task Contract 与 Review Gate。

推荐默认路径：

```text
User Goal
  ↓
Architect 建立 Task Contract
  ↓
需要事实？── yes → Investigator
  ↓                    │
Architecture Decision ←┘
  ↓
Programmer 实现 + 自验证
  ↓
独立验证（按风险需要）
  ↓
Architect Review Gate
  ↓
PASS / NEEDS_CHANGES / BLOCKED
```

## 4. 非目标

当前协议层不是工作流引擎，也不负责：

- 任务持久化；
- Agent 调度；
- 并发控制；
- 队列；
- 自动重试；
- 审批系统；
- UI；
- 运行时状态数据库。

第一阶段只建立稳定、可移植、可人工执行的组织协议。

后续如果真实使用证明有必要，再将这些协议映射为机器可执行状态模型。