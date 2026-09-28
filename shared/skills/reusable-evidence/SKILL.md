---
name: reusable-evidence
description: 将高成本、可复用、带明确失效条件的任务证据晋升为项目级长期工程证据。用于判断是否值得持久化、检查现有证据是否仍有效，以及按统一格式维护项目 `docs/evidence/`。普通测试结果、lint、临时日志和一次性局部调查不应进入长期证据。
---

# reusable-evidence

`reusable-evidence` 是项目级 **Reusable Evidence Cache** 的维护方法。

它解决的问题不是“如何保存所有验证结果”，而是：

> 哪些昂贵、稳定、未来很可能重复使用的事实值得跨任务保存，以及它们何时应被判定为失效？

本 Skill 的模板属于组织级能力；实际 Evidence 实例属于具体项目。

默认实例位置：

```text
docs/evidence/
```

# 1. 两类 Evidence

必须区分：

## Task-local Evidence

只服务当前 Task / PR / Review，例如：

- targeted test PASS；
- lint / typecheck PASS；
- 临时日志；
- 一次 grep；
- 某个当前代码行号；
- 普通局部调用链调查。

这些默认留在当前 Task Contract、PR、review report 或 worker 输出中，不进入 `docs/evidence/`。

## Reusable Evidence

只有同时具有较高复用价值和重新获取成本的事实才考虑长期保存，例如：

- 外部系统真实行为；
- 昂贵 live probe；
- 第三方 SDK / API 的实测限制；
- 难复现的兼容性事实；
- 关键 runtime semantics；
- 后续任务高概率再次依赖的 gate 事实。

长期保存不等于永久有效。

Reusable Evidence 本质上是：

> 带明确 invalidation 条件的工程事实缓存。

# 2. 谁负责晋升

Programmer / Investigator 负责提供任务内 Evidence。

Architect 负责判断：

```text
Task Evidence
→ discard after task / keep in task report
→ OR promote to Reusable Evidence
```

Worker 不应自行大量向 `docs/evidence/` 写入记录。

# 3. Promotion Criteria

只有满足大部分以下条件时才考虑晋升：

1. 后续任务很可能再次需要这个事实；
2. 重新获取明显昂贵、耗时或有副作用；
3. claim 可以清晰表达；
4. evidence 可以脱敏后保存；
5. 能定义明确 `invalidated_by`；
6. 保存该事实比未来重新验证更便宜。

如果只是普通本地测试结果，不晋升。

# 4. 不应晋升的内容

通常不要进入长期 Evidence：

- lint PASS；
- typecheck PASS；
- full test PASS；
- 单测数量；
- 当前文件行号；
- 一次性局部实现细节；
- 容易通过源码立即重新获得的事实；
- 没有明确复用价值的调查结果。

# 5. Evidence Format

创建长期 Evidence 时使用 `templates/evidence.md`。

至少记录：

```yaml
id:
status:
claim:
result:
verified_at:
baseline:
evidence:
invalidated_by:
```

推荐 status：

```text
VALID
STALE
SUPERSEDED
```

不要使用永久有效之类的状态。

# 6. Invalidation

复用 Evidence 前必须检查：

1. baseline 是否仍适用；
2. `invalidated_by` 中列出的代码、配置、外部系统或环境是否变化；
3. 当前观察是否与已有 Evidence 冲突。

如果触发 invalidation：

```text
VALID → STALE
```

然后根据当前任务是否需要该事实，决定是否重新验证。

不要因为文档存在就无条件复用。

# 7. External Evidence

对于 OAuth、Auth0、Cloud provider、外部 API、生产行为等 live probe，优先保存：

- claim；
- 环境；
- 时间；
- 脱敏请求 / 响应摘要；
- 关键 before / action / after；
- cleanup；
- invalidation 条件。

不要保存完整 token 或 secret。

# 8. Security / Privacy

`docs/evidence/` 默认进入 Git，因此禁止写入：

- access token；
- refresh token；
- cookie；
- password；
- client secret；
- private key；
- 未经允许的个人敏感数据；
- 任何项目规则禁止提交的 confidential material。

必要时只保留脱敏摘要，例如：

```text
HTTP 201
client type = third-party strict
scope = read/write
```

而不是原始凭据或完整敏感 payload。

# 9. Project Directory

如果项目第一次产生 Reusable Evidence，可创建：

```text
docs/evidence/
```

无需提前在所有项目中创建空目录。

Evidence 文件名应表达事实主题，例如：

```text
docs/evidence/auth0-dcr-strict.md
docs/evidence/assignment-terminal-reassign.md
```

不要按 Agent、日期或个人姓名组织目录。

# 10. Reuse Flow

未来 Task 使用已有 Evidence 时：

```text
Locate candidate evidence
→ Check status
→ Check baseline
→ Check invalidated_by
→ Reuse if valid
→ Otherwise mark stale and re-verify only if needed
```

Task Contract 中只需要引用相应 Evidence，而不是复制整份内容。

# 11. Update / Supersede

如果同一个 claim 被重新验证且结论更新：

- 优先更新同一 Evidence 文件并保留历史说明；或
- 当语义本身发生重大变化时，将旧记录标记 `SUPERSEDED` 并链接新 Evidence。

不要让多个相互矛盾的 `VALID` 记录长期共存。

# 12. Stop Rule

维护 Evidence 的目标是减少未来重复工作，不是建立完整知识库。

如果保存一条记录的维护成本可能高于未来重新验证成本：

> 不保存。

最终原则：

> Promote selectively.
> Persist project facts, not task noise.
> Reuse only while valid.
> Never persist secrets.
