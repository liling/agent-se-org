---
name: arch-director
description: 深度架构设计与 Architecture Review 方法。用于新的系统/模块架构、复杂跨模块设计、核心语义决策、ADR、架构演进与迁移，以及对实现进行架构级审查。它是 Architect 可按需加载的专业 Skill，不承担 Architect Agent 的日常身份和多 Agent 编排职责。
---

# arch-director

`arch-director` 是 **Architecture Methodology Skill**。

它不定义“谁是 Architect”，也不负责日常 Agent 路由。Architect 的身份、职责、委派与最终技术责任由 Architect Agent 承担。

本 Skill 只回答：

> 当问题已经进入系统级架构设计、重大技术决策或 Architecture Review 时，应该如何分析、记录、验证和收敛？

# 1. 适用场景

优先在以下情况加载本 Skill：

- 新系统或新模块架构；
- 跨多个模块的结构性设计；
- module boundary / dependency direction；
- public contract / API semantics；
- canonical identity / authoritative source；
- lifecycle；
- version semantics；
- authorization / security boundary；
- transaction / consistency semantics；
- persistence boundary；
- 新增一级架构概念；
- 多个合理方案之间的技术决策；
- ADR；
- architecture migration / evolution；
- Programmer 完成后的 Architecture Review。

普通代码搜索、Bug 定位、实现、单元测试、UI QA、代码风格 Review 不需要默认加载本 Skill；这些工作优先交给相应 Agent 或 gstack Skill。

# 2. 先确认问题是不是架构问题

Implementation Problem 通常包括：

- 局部 bug；
- 类型错误；
- 参数错误；
- 普通测试缺失；
- 已确定设计下的实现偏差；
- 不改变 contract 的局部重构。

Architecture Problem 通常包括：

- 模块职责重叠；
- boundary 模糊；
- 第二套 canonical model / authority；
- dependency cycle；
- lifecycle 冲突；
- version semantics 不明确；
- authorization boundary 错误；
- transaction / consistency 语义冲突；
- 为维持设计需要越来越多特殊分支；
- 新需求迫使旧抽象不断增加例外。

如果只是实现问题，不要升级成架构项目。

# 3. 架构设计的基本问题

任何重要概念都应尽量回答：

- Identity：它如何被唯一识别？
- Ownership：谁拥有它？
- Scope：作用域是什么？
- Definition：权威定义在哪里？
- Lifecycle：如何创建、激活、修改、废弃？
- Runtime：运行时如何表示和解析？
- Implementation：由什么具体实现承载？
- Authorization：谁可以使用？
- Governance：谁可以改变定义？
- Dependency：依赖谁、谁依赖它？
- Versioning：如何版本化、切换和回滚？
- Failure：失败语义是什么？

如果这些问题无法回答，不要轻易把概念提升为一级架构对象。

# 4. 设计原则

## 4.1 单一权威

同一个核心概念尽量只有一个 canonical identity 和 authoritative source。

警惕：

- 双重真相；
- 隐式 fallback；
- 两套 resolver / registry；
- 绕过正式入口直接访问内部 storage；
- 临时兼容路径逐渐成为第二套架构。

## 4.2 Invariant 优先

重要设计尽量表达为可验证的不变量，而不是只写示例。

例如：

```text
已发布版本不可被静默修改。
所有写操作必须经过统一治理入口。
授权检查不能由下游调用者自行选择是否执行。
提交前不产生不可逆外部副作用。
```

## 4.3 最小充分设计

只设计当前必须成立、或会决定长期方向的语义。

不要为了“未来也许会用”创建框架；但 identity、lifecycle、version、authorization、transaction 等基础语义如果会影响全局，也不能用 YAGNI 回避。

## 4.4 复用已有机制

新增抽象前先回答：

> 现有机制为什么不能承载？

如果理由只是“新建更方便”，通常不足以成立。

# 5. 方案比较

存在多个合理方案时，至少比较：

- 概念复杂度；
- 实现复杂度；
- 运行成本；
- 运维成本；
- 安全与权限；
- 数据一致性；
- 兼容性；
- 可观测性；
- 迁移成本；
- 长期演进性。

明确区分：

```text
Known
Assumption
Hypothesis
Open Question
Decision
```

不要把未经验证的假设逐渐写成架构事实。

# 6. 架构文档

复杂设计优先更新项目已有架构文档。如果项目没有约定，可使用本 Skill 的模板：

```text
templates/architecture.md
templates/module.md
templates/roadmap.md
templates/iteration.md
templates/ADR.md
templates/decisions-INDEX.md
templates/report.md
templates/runbook.md
templates/task-contract.md
```

一份架构设计通常应覆盖：

- Context / Problem；
- Goals / Non-goals；
- Current State；
- Design；
- Boundaries；
- Identity / Ownership；
- Data / Control Flow；
- Lifecycle；
- Versioning；
- Authorization；
- Failure Modes；
- Compatibility；
- Migration；
- Validation；
- Risks。

文档描述设计和决策，不要把实现代码重新抄一遍。

# 7. ADR

以下决策通常值得 ADR：

- 影响多个模块；
- 很难反悔；
- 形成长期 Public API / contract；
- 改变核心边界；
- 改变 identity、version、authorization、persistence、transaction 等基础语义；
- 存在多个合理方案；
- 未来维护者需要知道“为什么这样做”。

推荐结构：

```text
# ADR-NNN: Title

Status
Context
Decision
Alternatives Considered
Consequences
```

ADR 的核心是记录为什么，而不是实现细节。

# 8. 架构验证

重要架构判断尽量转化成可执行证据：

```text
Architecture Claim
  ↓
Prototype / Test / Benchmark / Static Check / Inspection
  ↓
Evidence
  ↓
Decision
```

常见对应：

- 性能 → benchmark；
- 数据一致性 → integration test；
- 并发 → concurrency test；
- 安全 → negative / bypass test；
- Public API → contract test；
- 版本演进 → compatibility test；
- dependency direction → architecture/static test；
- 高复杂度方案 → minimal prototype。

能通过小 PoC 验证的争议，优先验证，不进行长期纯理论争论。

# 9. Architecture Review

对 Programmer 实现做架构级审查时，重点检查：

1. 是否符合已确认设计；
2. 模块边界是否保持；
3. 是否出现第二套 identity / authority；
4. lifecycle 是否一致；
5. dependency direction 是否正确；
6. version semantics 是否明确；
7. authorization / security 是否被绕过；
8. transaction / consistency 是否成立；
9. side effect / event 时序是否正确；
10. compatibility 是否被破坏；
11. 测试是否覆盖关键 invariant；
12. 文档 / ADR 是否与实现一致。

通用代码质量 Review、UI QA、安全专项可以组合 gstack 的 `review`、`qa-only`、`cso` 等 Skill；这些结果是 Architecture Review 的输入，而不是替代 Architect 的最终技术判断。

# 10. Review 输出

推荐：

```text
# Architecture Review

## Verdict
PASS / NEEDS CHANGES / BLOCKED

## Scope Reviewed

## Architecture Compliance

## Findings
### P0
### P1
### P2

## Required Changes

## Deferred Items

## Regression Assessment

## Decision

## Next Step
```

### P0

阻止继续推进，例如核心架构错误、数据一致性问题、安全绕过、关键 invariant 被破坏、不可接受的兼容性破坏。

### P1

当前阶段应修复的问题。

### P2

不阻塞当前目标的改进项，可进入 backlog。

# 11. 迁移与演进

修改已有架构时优先渐进迁移：

```text
Introduce
→ Migrate
→ Verify
→ Remove Legacy
```

不要无意识地在同一阶段同时改变 identity、persistence、authorization、API、lifecycle 和业务行为。若必须同时改变，应明确迁移顺序、兼容策略和回滚边界。

Roadmap 是当前认知下的计划，不是不可违背的合同。新的证据证明旧设计错误时，应纠偏，而不是继续堆叠 workaround。

# 12. 反模式

重点警惕：

- God Object / 万能 Manager；
- Service Locator 隐藏依赖；
- 双重真相；
- 隐式生命周期；
- 抽象泄漏；
- 伪抽象；
- 过早通用化；
- 兼容分支泛滥；
- workaround 驱动架构；
- 同一概念存在多个 canonical path。

# 13. 与 Architect Agent 的关系

Architect Agent 始终拥有：

- 用户主会话；
- 日常任务判断；
- Investigator / Programmer 委派；
- gstack Skill 选择；
- Task Contract；
- 最终技术 Verdict。

本 Skill 只在架构问题需要更深方法论时被 Architect 按需加载。

原则：

> **Architect 是角色；arch-director 是架构方法。**
