# Agent Software Engineering Organization

`agent-se-org` 是一套面向软件工程的 Multi-Agent 组织定义。

它的核心不是把所有规则放进全局 `AGENTS.md`，而是把组织运行责任交给明确的 **Architect primary agent**：Architect 理解用户目标、选择 Investigator / Programmer、组合 Skills、做技术与架构决策，并对最终结果负责。

## 核心模型

```text
User
  ↓
Architect (primary)
  ├── Investigator
  ├── Programmer
  ├── arch-director
  └── gstack / other Skills
  ↓
Architect Verdict
```

基本分工：

```text
Architect     = 判断 + 架构 + 编排 + 最终验收
Investigator  = 调查 + 诊断 + 独立验证
Programmer    = 正式实现 + 测试 + 修复
arch-director = 深度架构方法 Skill
gstack        = 通用软件工程方法 Skills
```

## Architect 是 Organization Runtime

本项目不再把 `shared/AGENTS.md` 当作完整的组织手册。

真正的组织运行规则集中在：

```text
agents/architect.md
```

Architect 从自己的视角理解整个组织：

- 谁负责调查；
- 谁负责实现；
- 哪些技术/架构决策不能下放；
- 如何建立 Task Contract；
- 如何选择 gstack / arch-director；
- 如何控制 Scope；
- 需要什么验证证据；
- 什么时候安排独立验证；
- 如何维护 design / architecture / ADR；
- 最终如何给出 PASS / NEEDS CHANGES / BLOCKED。

这样 Investigator 和 Programmer 不需要加载大量与自身无关的组织编排规则。

## AGENTS.md 的定位

`shared/AGENTS.md` 现在只是一个极薄的 bootstrap：

- 告诉环境软件工程任务优先从 `architect` 开始；
- 简要说明三个角色；
- 声明项目自身更具体的规则优先。

它不再维护完整的软件工程纪律、流程、Agent 选择或 Review 规则。

因此即使未来 Installer 需要与用户已有的全局 `AGENTS.md` 共存，冲突面也会很小。

## Worker Roles

### Investigator

`agents/investigator.md` 只负责 Investigator 自身视角：

- 查找、调查、复现、诊断、root cause；
- 事实与证据；
- 独立验证；
- 不拥有系统级架构决策权；
- 默认不负责正式 Feature implementation。

### Programmer

`agents/programmer.md` 只负责 Programmer 自身视角：

- 实现、测试、修复；
- 在 Architect 给出的约束空间内自主决定局部实现；
- 不静默改变架构或扩大 Scope；
- 返回实现和验证证据。

即使用户在 OpenCode UI 中直接切换到 worker，它们仍知道自身边界。

## Role 与 Skill

Agent 是责任主体，Skill 是可组合方法。

```text
Architect != arch-director

Architect     = Role / Organization Runtime
arch-director = Architecture Methodology Skill
```

常见组合：

| 工作 | 默认承担者 | 可组合 Skill |
|---|---|---|
| 系统级架构设计 | Architect | `arch-director` |
| 工程计划复核 | Architect | gstack `plan-eng-review`, `autoplan` |
| Root Cause 调查 | Investigator | gstack `investigate` |
| 正式代码实现 | Programmer | 必要时 `investigate` |
| 工程代码 Review | Architect 编排 | gstack `review` |
| UI 边验收边修复 | Programmer | gstack `qa` |
| UI 独立验收 | Investigator | gstack `qa-only` |
| 安全专项 | 按 Architect 委派 | gstack `cso` |
| 发布前 gate | Architect 编排 | gstack `ship` |
| 上线后检查 | 按发布流程 | gstack `canary` |

Skill 名称以当前环境实际可见结果为准；gstack 可能使用 `gstack-*` 前缀。

`agent-se-org` 不 vendor / fork gstack。

## Task Contract

Architect 向 worker 委派非平凡任务时至少明确：

```text
Goal
Context
Scope
Non-goals
Constraints / Invariants
Required Evidence
Acceptance Criteria
```

Task Contract 是 Agent 间的消息契约，不是新的 runtime primitive。

## 文档责任

Architect 默认区分：

```text
docs/designs/       Change / Feature Design：准备怎么改

docs/architecture/  长期系统架构事实

docs/decisions/     ADR：长期决策及原因

roadmap / iteration  长期方向和阶段状态
```

Design 实施并验证后，再把稳定事实同步到 architecture / ADR。历史 ADR 不应被静默重写。

这与 gstack 的 repo-local design / plan 文档可以共存：gstack 主要参与 change-level design、plan review、QA、review 等专业工作；Architect 负责长期架构知识的 authority。

## 内容分层

| 层 | 目录 | 权威内容 |
|---|---|---|
| Bootstrap | `shared/AGENTS.md` | 极薄入口提示 |
| Agent Roles | `agents/` | Architect / Investigator / Programmer 的角色视角 |
| Shared Skills | `shared/skills/` | arch-director 等方法与模板 |
| Harness Adapter | `harness/<name>/` | mode / model / tools / 平台格式 |
| Deployment Image | `dist/<name>/` | 构建生成的部署镜像 |

## 目录结构

```text
agent-se-org/
  README.md
  build.sh

  shared/
    AGENTS.md
    skills/
      arch-director/
        SKILL.md
        templates/
          ...

  agents/
    architect.md
    investigator.md
    programmer.md

  harness/
    opencode/
      frontmatter/
        architect.md
        investigator.md
        programmer.md

  dist/
    opencode/
      AGENTS.md
      agents/
      skills/
```

## OpenCode

OpenCode adapter 将 Architect 定义为：

```yaml
mode: primary
```

因此它可以作为主 Agent 在 UI 中切换。

如果希望新会话默认进入 Architect，可在用户自己的 OpenCode 配置中设置：

```json
{
  "default_agent": "architect"
}
```

本仓库不强制覆盖这个用户偏好。

## 构建与部署

```bash
./build.sh
git diff dist/

cp -r ~/.config/opencode ~/.config/opencode.bak
cp -R dist/opencode/ ~/.config/opencode/
```

`build.sh` 会把 `harness/opencode/frontmatter/<agent>.md` 与 `agents/<agent>.md` 合成为最终 Agent 文件，同时复制 bootstrap 和 shared skills。

当前直接 copy 方式主要用于开发验证。未来正式发行更适合使用 Installer，以 merge / managed 的方式安装 Agents、Skills 和极薄 bootstrap，而不是覆盖用户整个 OpenCode 配置目录。

## gstack 安装

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack
./setup --host opencode
# 或
./setup --host codex
```

## 默认协作路径

```text
User Goal
  ↓
Architect 恢复当前状态
  ↓
事实不清？ ──→ Investigator
  ↓
Architect 做技术 / 架构决策
  ↓
需要深度架构方法？ ──→ arch-director
  ↓
需要计划复核？ ──→ gstack plan review
  ↓
Task Contract
  ↓
Programmer 实现、自验证
  ↓
按风险选择 independent verification / review / QA / security
  ↓
Architect 最终 Verdict
```

这不是固定工作流。简单任务应压缩流程，高风险、跨模块、事实不清或架构性任务才增加更多 gate。

## 设计原则

1. **Architect owns organization runtime**：组织如何运作主要由 Architect Agent 定义。
2. **Global instructions 最小化**：`AGENTS.md` 只保留 bootstrap，不重复角色行为。
3. **Role 与 Skill 分离**：Agent 是责任主体；Skill 是按需方法。
4. **Worker prompt 面向角色视角**：只保留自身职责、边界和返回契约。
5. **Architect 与 arch-director 分离**：日常组织属于 Agent，深度架构方法属于 Skill。
6. **证据驱动**：Programmer 的“已完成”不是最终 Verdict。
7. **Harness-neutral source**：平台差异留在 `harness/`。
8. **暂不引入 workflow runtime**：不增加 task database、scheduler、queue 等 primitive。
