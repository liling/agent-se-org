# Review Gate

Review Gate 定义 Architect 在一次任务结束前如何给出最终技术裁决。

目标是让“完成”建立在 Goal、Contract 和 Evidence 上，而不是建立在执行 Agent 的自我陈述上。

## 1. Verdict

仅使用以下三种最终状态：

### PASS

只有当以下条件同时成立时才能给出：

- Goal 已满足；
- 必要的架构约束未被破坏；
- Completion Criteria 全部满足；
- Required Evidence 已提供且可信；
- 未发现阻塞性 regression；
- 未存在未说明的 scope 扩张；
- 未遗留必须在当前任务内解决的 P0/P1 问题。

### NEEDS_CHANGES

用于目标方向正确、任务可继续，但当前实现或证据仍不满足验收条件。

典型原因：

- 行为只部分实现；
- 测试缺失；
- regression test 无效；
- 实现绕过既有机制；
- scope 超出 Contract；
- 错误语义不一致；
- UI 与确认设计不一致；
- 验证范围不足。

必须明确列出：

- 哪些条件未满足；
- 证据；
- 应返回 IMPLEMENTING 还是 INVESTIGATING。

### BLOCKED

用于当前无法安全继续或无法形成可靠结论。

典型原因：

- 必须由用户或 Architect 做新的关键决策；
- 权限不足；
- 外部依赖不可用；
- 环境不可复现；
- 关键事实证据互相冲突；
- 任务前提不成立。

BLOCKED 不是失败，也不能通过猜测绕过。

## 2. Review 输入

Architect Review 应优先读取：

1. 原始 Goal；
2. Task Contract；
3. Architect Decision / ADR（若有）；
4. 实际 diff；
5. Programmer 的验证结果；
6. Investigator 的独立验证（若有）；
7. 实际测试、lint、typecheck、build 或 UI 证据。

不能只根据 Programmer 的总结做 PASS。

## 3. Review 检查维度

### Behavior

- 用户目标是否真正实现；
- happy path / error path 是否符合预期；
- 是否存在只让测试通过但实际行为错误的情况。

### Architecture

- 是否尊重已有 module boundary；
- 是否复用已有 authority；
- 是否新增第二套模型 / Registry / Resolver / Repository / 权限路径；
- 是否产生 architecture bypass；
- 是否静默改变 Public API、数据模型、transaction、lifecycle、version semantics。

### Scope

- diff 是否与任务相关；
- 是否有顺手重构；
- 是否修改了 Forbidden Scope；
- 是否引入不必要依赖或扩展点。

### Verification

- Required Evidence 是否真的运行；
- 测试是否覆盖目标行为；
- regression test 是否先能证明问题；
- 是否仅修改 expected result；
- 是否需要更广泛测试但未执行。

### Risk

- Authorization / Security 是否可能绕过；
- transaction / migration 是否可能破坏已有数据；
- compatibility 是否改变；
- 是否存在明显但未处理的 regression。

## 4. Evidence 等级

Review 时优先相信可复现证据：

```text
实际运行结果 / test output / diff / screenshot / log
    >
代码阅读得到的直接证据
    >
项目文档
    >
Agent 推断
    >
无证据的自我声明
```

如果文档和代码冲突，应显式记录冲突，而不是自动选择文档或代码为真。

## 5. 推荐 Review Report

```markdown
# Review Report

## Verdict
PASS | NEEDS_CHANGES | BLOCKED

## Goal
原始目标是否满足。

## Contract Check
- [x] ...
- [ ] ...

## Architecture
关键边界是否保持。

## Evidence
实际运行过的测试、命令、diff、截图或调查证据。

## Findings
按严重程度列出发现。

## Required Follow-up
仅在 NEEDS_CHANGES / BLOCKED 时填写必须动作。

## Non-blocking Notes
可选的 P2 / 后续改进，不影响当前 Verdict。
```

## 6. 严重度

为了避免 Review 把所有问题混在一起，可以使用：

- `P0`：安全、数据损坏、核心架构破坏等立即阻塞；
- `P1`：当前 Goal / Contract 未满足，阻塞 PASS；
- `P2`：真实问题，但可以进入后续工作，不阻塞当前目标；
- `NOTE`：观察或建议，不等同于缺陷。

PASS 可以伴随 P2 / NOTE，但必须明确说明为什么不影响当前任务 Completion Criteria。

## 7. Review 的边界

Architect Review 不应：

- 为了快速 PASS 自己静默修实现；
- 在 Review 阶段重新设计整个系统；
- 把个人偏好当成 Blocking Finding；
- 因为存在未来可优化项就拒绝 PASS；
- 在没有证据时声称“没有 regression”。

Review 的任务是做技术验收和下一步裁决。