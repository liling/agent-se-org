# Iteration Protocol

本协议定义一次标准软件工程迭代如何在 Architect、Investigator、Programmer 之间流转。

它描述的是默认路径，不要求所有任务机械走完全部阶段。Architect 可以根据任务复杂度压缩阶段，但不能跳过必要的事实确认、验证和最终 Review。

## 1. 状态模型

推荐使用以下逻辑状态：

```text
INTAKE
  ↓
INVESTIGATING
  ↓
DECIDED
  ↓
IMPLEMENTING
  ↓
VERIFYING
  ↓
REVIEW
  ├── PASS → DONE
  ├── NEEDS_CHANGES → IMPLEMENTING / INVESTIGATING
  └── BLOCKED → WAITING_DECISION
```

这些状态当前是协作语义，不要求有数据库或工作流引擎。

## 2. Phase A — Intake / 恢复上下文

Architect 负责：

- 理解用户目标；
- 读取项目级 AGENTS.md、README、相关架构文档和 ADR；
- 判断任务是简单实现、调查、Bug、架构变更还是混合任务；
- 恢复已有 iteration / roadmap / review 状态；
- 确认是否需要显式 Task Contract。

输出至少包括：

- Goal；
- 当前已知事实；
- 未知点；
- 任务风险级别；
- 下一步委派策略。

## 3. Phase B — Investigation

当关键事实不清楚时，优先委派 Investigator。

典型调查内容：

- 实际调用链；
- 现有机制；
- 数据流；
- 版本与依赖；
- Bug reproduction；
- 测试覆盖；
- 文档与代码冲突；
- 外部官方资料。

Investigator 返回：

```text
Facts
Evidence
Root Cause / Unknowns
Constraints
Possible Options（如需要）
```

Investigator 不做系统级架构裁决。

若任务事实已经充分明确，可以跳过独立 Investigation。

## 4. Phase C — Architecture Decision

Architect 根据用户目标、调查证据和既有架构做出裁决。

需要明确：

- 采用什么方案；
- 为什么；
- 哪些替代方案被放弃；
- 修改边界；
- 不变量；
- 是否需要 ADR / design doc；
- 如何验证。

如果属于架构决策，应先把设计稳定下来，再进入实现。

禁止让 Programmer 在实现过程中被迫替 Architect 做隐藏的架构选择。

## 5. Phase D — Task Registration / Contract

对于非简单任务，Architect 建立或更新 Task Contract。

Contract 至少包含：

- Goal；
- Context；
- Constraints；
- Scope；
- Evidence；
- Completion Criteria；
- Escalation Conditions。

如果项目存在 roadmap / iteration 文档，应登记当前工作项和状态。

## 6. Phase E — Implementation

Programmer 根据 Contract 实现。

默认执行顺序：

```text
Read relevant code
  ↓
Confirm existing mechanism
  ↓
Make minimal change
  ↓
Add / update tests
  ↓
Targeted verification
  ↓
Broader verification as required
```

Programmer 必须：

- 尊重架构裁决；
- 控制修改范围；
- 不静默扩大 scope；
- 不创建第二套机制；
- 不通过削弱测试来制造 PASS；
- 对自己修改导致的问题负责清理。

遇到 Escalation Condition 时返回 Architect。

## 7. Phase F — Verification

验证分两层：

### Programmer Self-Verification

Programmer 必须证明实现至少满足 Contract 中要求的 Evidence。

### Independent Verification

以下情况建议由 Investigator 独立验证：

- Bug 修复；
- Authorization / Security；
- Transaction；
- Migration；
- 架构边界；
- UI 关键流程；
- 容易出现“测试绿但行为不对”的任务；
- Architect 对实现证据仍有疑问。

独立验证不能只是重复 Programmer 的结论，应读取实际 diff、运行实际测试或检查实际行为。

## 8. Phase G — Architect Review

Architect 按 `review-gate.md` 做最终 Review。

Review 不是重新实现，而是确认：

- Goal 是否真的满足；
- 架构是否保持一致；
- Contract 是否全部满足；
- Evidence 是否充分；
- 是否存在未说明的 scope 扩张；
- 是否存在新的风险或 debt。

最终 Verdict：

- `PASS`
- `NEEDS_CHANGES`
- `BLOCKED`

## 9. Phase H — Close / 回写

PASS 后，Architect 负责把长期状态回写到适当位置，例如：

- roadmap；
- iteration log；
- ADR；
- architecture doc；
- changelog；
- task tracker。

只记录未来仍有价值的信息。

不要为了留痕而复制整个对话。

## 10. 返工路径

### NEEDS_CHANGES

如果问题属于实现偏差：

```text
REVIEW → IMPLEMENTING → VERIFYING → REVIEW
```

如果 Review 暴露的是事实不清或根因判断错误：

```text
REVIEW → INVESTIGATING → DECIDED → IMPLEMENTING
```

### BLOCKED

进入 `WAITING_DECISION`，常见原因：

- 用户需求冲突；
- 必须做新的架构裁决；
- 外部依赖不可用；
- 权限不足；
- 关键证据无法获得。

不得用猜测绕过 BLOCKED。

## 11. 简单任务压缩

简单任务允许：

```text
INTAKE → IMPLEMENTING → VERIFYING → REVIEW → DONE
```

极小且无风险任务可以由 Architect 自己完成，但仍应遵守全局验证规则。

流程的目标是减少错误和返工，不是增加仪式。