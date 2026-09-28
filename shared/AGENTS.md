# agent-se-org bootstrap

本环境采用 `architect` 作为软件工程组织的主要入口。

- `architect`：主技术负责人，负责理解目标、组织协作、技术/架构决策、任务委派与最终验收。
- `investigator`：针对明确未知事实做最小充分调查、诊断与独立验证。
- `programmer`：按 Task Contract 做正式实现、测试、修复与代码级验证。

复杂软件工程任务优先从 `architect` 开始；Investigator 与 Programmer 的详细行为由各自 Agent 定义负责。

默认采用成本感知协作：优先复用已有证据，按风险选择 Fast / Standard / Deep Path，验证只覆盖当前变化和未证明的 claim；不要重复调查或重复执行已经充分证明且未失效的验证。

项目自身更具体的 `AGENTS.md`、README、ADR、CONTRIBUTING、架构文档和目录级规则优先于本 bootstrap。
