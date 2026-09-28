# Task Contract v2

> 用于 Architect 向 Investigator / Programmer 委派非平凡任务。只传完成当前任务所需信息，不复制全部项目上下文。

## Task

- ID:
- Title:
- Owner Agent:

## Workflow

选择其一：

```text
FAST
STANDARD
DEEP
```

## Objective

要达成的可验证目标。

## Baseline

- Commit / branch / environment:

## Known Facts

只写已经确认、当前任务需要依赖的事实。

## Unknowns

只写会影响当前任务、仍需要被调查的问题。

## Architecture

### Existing

当前 authoritative architecture / ADR / contract。

### Delta

本任务真正改变的设计。没有变化时明确写：

```text
Existing architecture: unchanged.
```

## Scope

允许调查或修改的范围。

## Allowed Changes

明确允许修改的内容。

## Forbidden Changes

当前任务不得改变的行为、模块或 contract。

## Non-goals

本任务明确不处理的事项。

## Constraints / Invariants

必须保持的架构、兼容性、安全、数据、事务、生命周期或版本不变量。

## Acceptance Criteria

可以客观判断完成与否的条件。

## Verification

### Level

选择最低必要等级：

```text
V0 — Inspect
V1 — Targeted
V2 — Related Suite
V3 — Full Repository
V4 — Live / External
```

### Required

只列出证明当前 claim 所必需的验证。

### Explicitly Not Required

明确列出不要执行的高成本动作，例如：

```text
- full repository test
- production deployment
- live OAuth probe
- independent re-run of already valid tests
```

不要因为“通常都会做”而自动执行这些动作。

## Reusable Evidence

记录可以直接复用、不要重新调查或重新执行的证据。

推荐格式：

```yaml
- id:
  claim:
  result:
  baseline:
  invalidated_by:
```

## Review

- Required: true / false
- Reason:
- Claims requiring independent review:

默认：

```text
FAST → false
STANDARD → usually false
DEEP → true
```

按真实风险覆盖，不机械执行。

## Stop When

定义任务停止条件，例如：

```text
- Acceptance Criteria 全部满足
- Required Verification 通过
- 没有 unresolved blocking evidence
```

满足后停止额外搜索、优化、清理和重复验证。

---

## Optional: Files / Modules to Inspect

建议优先查看的位置；不要为了保险无边界扩大搜索。

## Optional: Implementation Requirements

只有真正影响 contract / behavior 的实现要求才写，不规定无意义的局部细节。

## Optional: Reporting Requirements

默认 worker 只需返回：

```text
RESULT
CHANGES / FACTS
VERIFICATION / EVIDENCE
REUSED EVIDENCE
NOT RUN
FOLLOW-UP
```

除非明确要求，不写长篇重复报告。
