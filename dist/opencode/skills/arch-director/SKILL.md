---
name: arch-director
description: 深度架构设计与 Architecture Review 方法。用于新的系统/模块架构、复杂跨模块设计、核心语义决策、ADR、架构演进与迁移，以及对高风险实现进行架构级审查。它是 Architect 可按需加载的专业 Skill，不承担 Architect Agent 的日常身份和普通任务编排职责。
---

# arch-director

`arch-director` 是 **Architecture Methodology Skill**。

它不定义“谁是 Architect”，也不负责日常 Agent 路由。Architect 的身份、Task Contract、worker 委派和最终技术责任由 Architect Agent 承担。

本 Skill 只回答：

> 当问题已经真正进入系统级架构设计、重大技术决策或高风险 Architecture Review 时，应该如何分析、记录、验证和收敛？

核心原则：

> Architecture when necessary. Evidence proportional to risk. Review only what remains uncertain.

# 1. 先确认是不是架构问题

Implementation Problem 通常包括：

- 局部 bug；
- 类型或参数错误；
- 普通测试缺失；
- 已确定设计下的实现偏差；
- 不改变 contract 的局部重构；
- 已有 pattern 的重复实现。

Architecture Problem 通常包括：

- 新系统或新模块边界；
- module ownership / dependency direction；
- public contract / API semantics；
- canonical identity / authoritative source；
- lifecycle；
- version semantics；
- authorization / security boundary；
- transaction / consistency semantics；
- persistence boundary；
- migration strategy；
- distributed semantics；
- 新的一级架构概念；
- 第二套 canonical model / authority；
- 旧 abstraction 被新需求持续迫使增加例外。

如果只是实现问题，不要升级成架构项目，也不要加载本 Skill 重新讲一遍架构方法论。

# 2. Architecture Reuse First

开始设计前先确认：

> 已有 ADR / Architecture Doc 是否已经回答这个问题？

如果已经回答，默认它是当前权威。

优先只描述本次 Architecture Delta：

```text
Existing architecture: unchanged.

Delta:
- ...
```

不要每个任务都重新恢复和输出完整系统设计。

只有以下情况才重新打开已有决策：

1. 当前 requirement 与既有架构冲突；
2. 新证据证明现有 abstraction 不足；
3. 实际代码已经偏离 authoritative docs；
4. 用户明确要求重新设计。

# 3. Known / Unknown / Decision

明确区分：

```text
FACT
ASSUMPTION
HYPOTHESIS
UNKNOWN
DECISION
```

不要让 UNKNOWN 悄悄变成架构事实。

如果一个未知事实会改变架构决策，优先让 Investigator 用窄问题取得最小充分证据。

例如：

```text
QUESTION:
terminal 状态重复 assignment 是否产生新 Run？

SCOPE:
只验证 terminal repeated assignment。

STOP WHEN:
行为可以可靠判定。
```

不要因为一个未知点让 Investigator 全面审计整个 subsystem。

# 4. 架构设计的基本问题

对真正重要的概念，尽量回答：

- Identity：如何唯一识别？
- Ownership：谁拥有？
- Scope：作用域是什么？
- Definition：权威定义在哪里？
- Lifecycle：如何创建、激活、修改、废弃？
- Runtime：运行时如何表示和解析？
- Authorization：谁可以使用？
- Governance：谁可以改变？
- Dependency：依赖谁、谁依赖它？
- Versioning：如何切换、兼容和回滚？
- Failure：失败语义是什么？

但只回答与当前 Architecture Decision 有关的维度，不机械补齐模板。

# 5. 设计原则

## 5.1 单一权威

同一个核心概念尽量只有一个 canonical identity 和 authoritative source。

警惕：

- 双重真相；
- 隐式 fallback；
- 两套 resolver / registry；
- 绕过正式入口直接访问内部 storage；
- 临时兼容路径逐渐成为第二套架构。

## 5.2 Invariant 优先

重要设计尽量表达为可验证不变量，而不是只写示例。

例如：

```text
已发布版本不可被静默修改。
所有写操作必须经过统一治理入口。
授权检查不能由下游调用者选择是否执行。
```

## 5.3 最小充分设计

只设计当前必须成立、或会决定长期方向的语义。

不要为了假设中的未来创建 framework / plugin layer / generic DSL / extension point。

## 5.4 复用已有机制

新增 abstraction 前先回答：

> 现有权威机制为什么不能承载？

如果理由只是“新建更方便”，通常不足以成立。

# 6. Workflow Risk

Architecture 任务也应区分风险，不要全部按最高规格执行。

## STANDARD ARCHITECTURE

适合：

- 有有限 design delta；
- 可回滚；
- 不涉及安全、持久化、迁移等基础语义；
- 影响范围可控。

通常：

```text
Architecture Delta
→ Task Contract
→ Programmer
→ V1 / V2
→ Evidence Review
```

## DEEP ARCHITECTURE

适合：

- persistence；
- authorization / security；
- identity / lifecycle；
- transaction / consistency；
- versioning / migration；
- distributed semantics；
- production-critical irreversible change。

通常：

```text
Focused Investigation
→ Architecture Decision / ADR
→ Task Contract
→ Implementation
→ V3 / V4
→ Independent Architecture Review
```

# 7. Evidence Reuse

架构工作也必须复用已证明事实。

优先引用：

- previous Architecture Gate；
- existing ADR；
- previous benchmark / test；
- live probe；
- prior implementation report；
- Evidence Ledger。

如果 evidence 的 baseline 和 invalidation 条件仍成立，不重新跑。

特别是 external probe：Auth0 / OAuth / cloud deployment / production API / DB 环境，不要为了“再次确认”制造新的 client、grant、token 或其他副作用。

# 8. Verification Is Claim-Driven

重要架构判断尽量转成：

```text
Architecture Claim
→ Smallest Useful Test / Prototype / Inspection
→ Evidence
→ Decision
```

常见对应：

- 性能 → benchmark；
- 一致性 → integration test；
- 并发 → concurrency test；
- 安全 → negative / bypass test；
- Public API → contract test；
- 版本演进 → compatibility test；
- dependency direction → static / architecture test；
- 高不确定方案 → minimal prototype。

不要为了“完整”自动运行全套验证。

每个验证都必须回答：

> 它在证明哪个尚未被证明的 claim？

# 9. Architecture Review Is Evidence Review

Architecture Review 的职责不是从零重新设计和重新执行全部测试。

Review 顺序：

1. 已确认 Architecture Decision；
2. Task Contract；
3. actual diff；
4. Programmer Evidence；
5. Acceptance Criteria；
6. 尚未证明或高风险的 claim。

重点检查：

- 是否符合已确认设计；
- 是否保持 module boundary；
- 是否出现第二套 identity / authority；
- lifecycle / version semantics 是否保持；
- authorization / transaction 是否被绕过；
- dependency direction 是否正确；
- compatibility / migration 是否符合决策；
- tests 是否覆盖关键 invariant；
- docs / ADR 是否与真实实现一致。

只有以下情况才重新执行已有测试：

- evidence 缺失或失效；
- evidence 与 diff 矛盾；
- 测试明显没有证明 claim；
- security / migration 等高风险问题需要独立确认；
- external state 已变化；
- Programmer 结果明显异常。

否则接受有效 evidence。

# 10. Review 输出

推荐：

```text
# Architecture Review

## Verdict
PASS / PASS WITH FOLLOW-UP / NEEDS CHANGES / BLOCKED

## Architecture Delta

## Evidence Reviewed

## Unproven / High-Risk Claims

## Required Changes

## Deferred Follow-up

## Not Repeated
- 已有且仍有效的验证
```

不要为了报告完整而重复大量背景。

# 11. ADR Threshold

不是每个决定都需要 ADR。

通常只有以下情况值得 ADR：

- 长期跨模块影响；
- 很难逆转；
- 形成长期 public contract；
- 改变核心 boundary；
- 改变 identity / version / authorization / persistence / transaction 等基础语义；
- 存在多个合理方案且未来维护者需要知道“为什么”。

局部实现选择留在 Task Contract 或代码即可。

# 12. 文档

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

文档只写当前需要持久化的决策和事实，不把实现代码重新抄一遍。

# 13. Migration

修改已有架构时优先：

```text
Introduce
→ Migrate
→ Verify
→ Remove Legacy
```

不要无意识地在同一阶段同时改变 identity、persistence、authorization、API、lifecycle 和业务行为。

如果必须同时改变，明确顺序、兼容边界、验证 claim 和 rollback point。

# 14. Stop Conditions

Architecture 工作也必须停止。

典型：

```yaml
stop_when:
  - blocking unknowns resolved
  - architecture decision made
  - task contract is implementable
  - required evidence is sufficient
```

经常问：

```text
继续调查会改变 Architecture Decision 吗？
```

不会 → 停止。

```text
继续 Review 会发现当前未覆盖的高风险 claim 吗？
```

不会 → 停止。

# 15. 反模式

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
- 同一概念多个 canonical path；
- architecture rediscovery；
- review = rerun everything；
- investigation without stop condition。

# 16. 与 Architect Agent 的关系

Architect Agent 始终拥有：

- 用户主会话；
- 日常任务判断；
- FAST / STANDARD / DEEP 路由；
- Investigator / Programmer 委派；
- Task Contract；
- Verification Level；
- 最终技术 Verdict。

本 Skill 只在架构问题需要更深方法论时被按需加载。

原则：

> **Architect 是角色；arch-director 是架构方法。**

以及：

> **Reuse what is already proven. Review only what remains uncertain. Stop when the decision is sufficiently supported.**
