# Reusable Evidence

```yaml
id: <stable-id>
status: VALID # VALID | STALE | SUPERSEDED
claim: <被验证的事实>
result: <结论>
verified_at: <YYYY-MM-DD>
baseline:
  commit: <commit-or-n/a>
  environment: <environment-or-n/a>
source:
  task: <task/pr/report reference if useful>
evidence:
  - <最小充分、已脱敏的证据>
invalidated_by:
  - <会使本证据失效的代码/配置/环境变化>
```

## Context

只保留理解 claim 所需的最小背景。

## Verification

记录关键验证方式、before / action / after 或官方/运行时证据摘要。

不要粘贴无必要的完整日志、完整响应或大量命令输出。

## Reuse Conditions

说明复用前必须确认的条件。

## Security / Redaction

确认本文不包含 token、cookie、password、client secret、private key 或其他禁止提交到 Git 的敏感信息。

## History

仅在重新验证、失效或 supersede 时追加简短记录。
