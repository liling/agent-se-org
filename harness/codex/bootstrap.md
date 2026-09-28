# agent-se-org bootstrap (Codex)

本环境采用 `architect` 作为软件工程组织的入口。

非平凡软件工程任务优先唤醒 Architect agent：

```text
spawn_agent(agent_type="architect", message="<用户目标与必要上下文>")
```

由 Architect 负责理解目标、判断问题类型、做技术与架构决策、委派 investigator / programmer，并对最终结果给出 Verdict。

主 agent 自行处理、不必唤醒 Architect 的场景：

- 简单、机械、纯事实性问题；
- 单文件、边界清晰的小改动；
- 直接的问答与说明。

`investigator` 与 `programmer` 通常由 Architect 委派，主 agent 不直接调度。

默认采用成本感知协作：优先复用已有证据，按风险选择 Fast / Standard / Deep Path，验证只覆盖当前变化和未证明的 claim；不要重复调查或重复执行已经充分证明且未失效的验证。

项目自身更具体的 `AGENTS.md`、README、ADR、CONTRIBUTING、架构文档和目录级规则优先于本 bootstrap。
