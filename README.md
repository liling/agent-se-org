# Agent Software Engineering Organization

`agent-se-org` 是软件工程 Multi-Agent 协作机制的单一内容源。

它不试图自己实现完整的软件工程方法库，而是负责定义：

- **Organization Rules**：所有角色共同遵守的组织规则；
- **Agent Roles**：Architect / Investigator / Programmer 的职责、权限和边界；
- **Orchestration**：Architect 如何选择角色、建立 Task Contract、组合专业 Skills 并做最终决策；
- **Harness Adaptation**：把同一套组织模型适配到 OpenCode、Codex 等 Agent 运行平台。

专业的软件工程方法优先复用 **gstack** 等 Skill 包，例如 investigation、plan review、code review、QA、security、ship，而不是在本仓库重复维护一套方法论。

## 核心模型

```text
                         User
                           │
                           ▼
                 Architect / Primary
                 (arch-director Skill)
                           │
             ┌─────────────┼─────────────┐
             │             │             │
             ▼             ▼             ▼
       Investigator     Programmer     gstack Skills
       查清 / 验证      实现 / 修复     专业工程能力
             │             │             │
             └─────────────┴─────────────┘
                           │
                           ▼
                    Architect Review
```

基本分工：

```text
Architect 负责判断与编排
Investigator 负责查清与独立验证
Programmer 负责正式实现与修复
gstack 提供专业工程方法与工具化 Skill
```

Architect 是 Primary Role，不作为普通 worker subagent 使用。

## 为什么使用 gstack

角色定义主要回答 **WHO**：谁负责什么、谁有什么决策权、谁不能做什么。

gstack 主要回答 **HOW**：调查 Bug、做工程计划审查、代码 Review、UI QA、安全检查、发布 gate 时采用什么专业方法。

典型组合：

| 工作 | 默认承担者 | 可组合的 gstack Skill |
|---|---|---|
| 架构与技术决策 | Architect | `plan-eng-review`, `autoplan` |
| Root Cause 调查 | Investigator | `investigate` |
| 代码实现 | Programmer | 实现过程中可用 `investigate` |
| 代码工程审查 | Programmer / Investigator / Architect | `review` |
| UI 边验收边修复 | Programmer | `qa` |
| UI 独立验收 | Investigator | `qa-only` |
| 视觉检查 | Investigator / Programmer | `design-review` |
| 安全专项 | 按 Architect 委派 | `cso` |
| 发布前 gate | Architect 编排 | `ship` |
| 上线后检查 | 按发布流程 | `canary` |
| 独立模型意见 | Architect 按需 | `codex` / `claude-code`（按当前 harness 可用项） |

表中的名字是逻辑 Skill 名。gstack 可能以 prefix 模式暴露为 `gstack-investigate`、`gstack-review` 等，也可能在 no-prefix 模式下暴露为 `investigate`、`review`。运行时必须使用当前环境实际发现的名称。

`agent-se-org` 不 vendor / fork gstack。

## Task Contract

Agent 间的任务委派使用轻量 Task Contract，而不是引入新的 workflow runtime。

核心字段：

```text
Goal
Context
Scope
Non-goals
Constraints / Invariants
Required Evidence
Acceptance Criteria
```

模板位于：

```text
shared/skills/arch-director/templates/task-contract.md
```

Task Contract 是 Architect 发给 worker 的**消息契约**，不是独立 Agent，也不是 Skill 类型。

## 内容分层

| 层 | 目录 | 权威内容 | 跨 harness |
|---|---|---|:---:|
| Organization Rules | `shared/AGENTS.md` | 全局协作规范与工程底线 | ✓ |
| Orchestrator Skill | `shared/skills/arch-director/` | Architect 的编排、决策、Task Contract 与模板 | ✓ |
| Agent Roles | `agents/` | Investigator / Programmer 角色正文，无 frontmatter | ✓ |
| Harness Adapter | `harness/<name>/` | mode / model / tools / 平台格式 | ✗ |
| Deployment Image | `dist/<name>/` | 构建生成的完整部署镜像 | generated |

一条规则只保留一个权威出处。

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
          architecture.md
          module.md
          roadmap.md
          iteration.md
          ADR.md
          decisions-INDEX.md
          report.md
          runbook.md
          task-contract.md

  agents/
    investigator.md
    programmer.md

  harness/
    opencode/
      frontmatter/
        investigator.md
        programmer.md

  dist/
    opencode/
      AGENTS.md
      agents/
      skills/
```

## OpenCode 构建与部署

```bash
./build.sh
git diff dist/

# 部署前建议先备份
cp -r ~/.config/opencode ~/.config/opencode.bak
cp -R dist/opencode/ ~/.config/opencode/
```

构建只生成 OpenCode 真正认识的组织内容：

```text
AGENTS.md
agents/
skills/
```

不会生成自定义 `protocols/` runtime 类型。

## gstack 安装

gstack 按其官方方式单独安装，不作为本仓库的构建产物。

当前官方 setup 支持显式选择 host：

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack

# OpenCode
./setup --host opencode

# Codex CLI
./setup --host codex
```

OpenCode 的 gstack skills 会安装到 `~/.config/opencode/skills/gstack-*/`；Codex 会安装到 `${CODEX_HOME:-~/.codex}/skills/gstack-*/`。

gstack 支持 prefix / no-prefix 模式，因此运行时可能暴露为 `gstack-investigate`，也可能是 `investigate`。Agent 必须以当前环境实际发现的 Skill 名称为准，不把名称猜测当成已安装事实。

outside review 也按 harness 路由：Codex 环境可使用 gstack 的 Claude Code outside reviewer；其他支持环境可使用 Codex outside reviewer。具体能力以当前 gstack 版本和本机已安装 CLI 为准。

## 默认协作路径

```text
User Goal
  ↓
Architect 恢复项目状态
  ↓
事实不清？ ──→ Investigator (+ gstack investigate / browse)
  ↓
Architect 做设计 / 技术决策
  ↓
复杂计划？ ──→ gstack plan-eng-review / autoplan
  ↓
Architect 建立 Task Contract
  ↓
Programmer 实现、自验证
  ↓
按风险选择 review / qa / qa-only / cso / outside review
  ↓
Architect 最终 Review
  ↓
PASS / NEEDS CHANGES / BLOCKED
```

这不是强制的固定工作流。简单任务应压缩流程；高风险、跨模块或事实不清的任务应增加调查和独立验证。

## 设计原则

1. **Organization 与 Methodology 分离**：本仓库定义组织，gstack 等 Skill 包提供专业方法。
2. **Role 与 Skill 分离**：Agent 是职责主体；Skill 是可组合能力。
3. **Architect 持有最终技术决策权**：worker 可以挑战设计，但不能静默改变架构。
4. **Investigator 与 Programmer 分工**：调查/独立验证与正式实现尽量分离。
5. **证据驱动**：Programmer 的“已完成”不是最终 Verdict。
6. **不重复维护方法论**：gstack 已有能力不再复制进 Agent prompt。
7. **Harness-neutral source**：平台差异留在 `harness/`，共享角色和方法保持单源。
8. **先稳定组织协议，再自动化执行**：当前不引入 task database、scheduler、queue 或 workflow engine。

## 后续方向

### Codex adapter

增加 `harness/codex/`，将相同的 Organization Rules、Agent Roles 和 arch-director 映射到 Codex 的实际 instructions / agents / skills 机制。

### gstack capability discovery

部署验证中确认 OpenCode / Codex 下实际安装的 gstack Skill 名称和调用方式，避免依赖过时名称。

### 自动化编排

只有在真实项目反复运行证明有必要后，再考虑把 Task Contract、状态和 Review loop 映射为机器可执行 workflow。不要提前创建新的 runtime primitive。
