# Task Contract

Task Contract 是 Architect / Primary Agent 向 Investigator、Programmer 或其他执行角色委派任务时的标准契约。

目的不是增加文档负担，而是把关键上下文从“隐含在对话里”变成“可验证的任务边界”。

## 1. 何时必须使用

以下情况建议显式建立 Task Contract：

- 任务跨多个文件或模块；
- 涉及 Public API、数据模型、权限、事务、生命周期、版本语义；
- 需要 Investigator 与 Programmer 协作；
- 需要独立验证或 Review Gate；
- 任务预计会经历多轮修改；
- 失败成本较高；
- 任务会跨会话、跨 Agent 或跨 harness 延续。

对于明显、局部、低风险的小任务，可以只保留精简版 Contract。

## 2. 标准结构

```markdown
# Task Contract

## Goal
要实现或确认的最终行为。

## Context
完成任务必须知道的背景、现状和已有决策。

## Constraints
不可违反的架构、兼容性、安全、性能或项目约束。

## Allowed Scope
允许读取、修改或新增的范围。

## Forbidden Scope
明确禁止修改或绕过的范围。

## Required Evidence
完成任务必须提供的事实、测试、命令输出、截图、diff 或其他证据。

## Expected Artifact
预期交付物，例如代码、调查报告、ADR、测试、Review Report。

## Completion Criteria
什么条件全部满足后，任务才算完成。

## Escalation Conditions
遇到哪些情况必须停止扩展并返回 Architect 决策。
```

## 3. 字段语义

### Goal

Goal 描述“需要成立的行为”，而不是“要修改哪些文件”。

推荐：

> 当用户缺少 `resource:write` 权限时，所有写入路径必须拒绝操作，并保持现有错误语义。

不推荐：

> 修改 authorization.ts。

### Context

只提供执行任务所需的上下文，例如：

- 当前行为；
- 相关 ADR；
- 现有调用链；
- 已知失败；
- 之前已经确认的架构裁决。

不要把整个项目历史全部复制进 Contract。

### Constraints

这里记录“不能为了完成任务而破坏的东西”。

例如：

- 不得新增第二套 authoritative source；
- 所有写操作必须经过 Governance Engine；
- Runtime / Control Plane 边界不可改变；
- 不允许改变 Public API；
- 不增加新依赖。

### Allowed Scope / Forbidden Scope

用于防止实现过程中静默扩张任务。

如果完成任务确实需要突破 Forbidden Scope，执行 Agent 应停止相关修改并返回 Architect，而不是自行改变边界。

### Required Evidence

Evidence 必须和 Goal 对应。

常见证据：

- targeted test；
- regression test；
- full test suite；
- lint；
- typecheck；
- build；
- architecture test；
- 实际调用链；
- runtime log；
- before / after screenshot；
- git diff。

不要把“Agent 说已经完成”当成证据。

### Expected Artifact

Artifact 是可交付结果，不一定是代码。

例如：

- investigation report；
- implementation diff；
- ADR；
- migration；
- regression test；
- review report；
- screenshot evidence。

### Completion Criteria

Completion Criteria 必须可以逐项判断成立或不成立。

例如：

- 新增的未授权路径测试失败后可复现原 Bug；
- 修复后 targeted tests PASS；
- authorization test suite PASS；
- typecheck PASS；
- 无新增 authorization bypass；
- Architect Review = PASS。

避免使用：

- “效果不错”；
- “基本完成”；
- “应该没问题”。

### Escalation Conditions

常见触发条件：

- 需要改变 Public API；
- 与已有 ADR 冲突；
- 发现第二套模型或重复 authority；
- 需要扩大数据模型；
- 需要改变权限 / transaction / lifecycle / version semantics；
- 任务范围显著超过原估计；
- 证据互相冲突，无法确定事实。

## 4. 精简版 Contract

简单任务可以使用：

```markdown
Goal:
Scope:
Constraints:
Evidence:
Done When:
```

关键不是格式，而是确保 Goal、边界、证据和完成条件明确。

## 5. 委派规则

Architect 在委派前负责确保 Contract 足够清楚。

Investigator / Programmer 接到 Contract 后：

1. 先验证 Context 与代码现实是否一致；
2. 在 Allowed Scope 内行动；
3. 如果遇到 Escalation Condition，不得静默改变架构；
4. 返回结果时逐项对应 Required Evidence 和 Completion Criteria；
5. 明确区分“已执行”“已验证”“未验证”。

Task Contract 是协作接口，不是形式主义文档。