# Agent Software Engineering Organization

`agent-se-org` 是软件工程 Multi-Agent 协作机制的单一内容源。

它负责定义：

- **Organization Rules**：所有角色共同遵守的组织规则；
- **Agent Roles**：Architect / Investigator / Programmer 的职责、权限和边界；
- **Orchestration**：Architect 如何选择角色、建立 Task Contract、组合专业 Skills 并做最终决策；
- **Harness Adaptation**：把同一套组织模型适配到 OpenCode、Codex 等运行平台。

专业软件工程方法优先复用 **gstack** 等 Skill 包，而不是在本仓库重复维护。

## 核心模型

```text
                         User
                           │
                           ▼
                     Architect
                  OpenCode primary
                           │
             ┌─────────────┼─────────────┐
             │             │             │
             ▼             ▼             ▼
       Investigator     Programmer     Skills
       查清 / 验证      实现 / 修复     专业方法
             │             │             │
             └─────────────┴─────────────┘
                           │
                           ▼
                    Architect Verdict
```

基本分工：

```text
Architect 负责判断、架构、编排与最终验收
Investigator 负责调查、诊断与独立验证
Programmer 负责正式实现、测试与修复
arch-director 提供深度架构方法
gstack 提供通用软件工程专业 Skills
```

## Role 与 Skill

这是本仓库最重要的分层。

### Agent Role

回答：**谁负责？谁有决策权？谁可以修改什么？**

当前三个角色：

- `architect`：主技术负责人；
- `investigator`：调查 / 验证 worker；
- `programmer`：实现 worker。

### Skill

回答：**某类专业工作应该如何做？**

例如：

- `arch-director`：系统级架构设计、ADR、架构演进和 Architecture Review；
- gstack `investigate`：root cause 调查；
- gstack `review`：工程代码 Review；
- gstack `qa` / `qa-only`：UI QA；
- gstack `cso`：安全专项；
- gstack `ship`：发布前 gate。

因此：

```text
Architect != arch-director

Architect     = Role
arch-director = Architecture Methodology Skill
```

Architect 平时不需要一直加载 `arch-director`；只有进入系统级架构问题时再按需使用。

## OpenCode 中的 Architect

OpenCode adapter 将 `architect` 定义为：

```yaml
mode: primary
```

因此它是 OpenCode 的可切换主 Agent，可以在会话中通过 Tab / `switch_agent` 与其它 primary agent 切换。

当前仓库**不会强制把 Architect 设为 OpenCode 默认 Agent**，以免覆盖用户已有配置。如果希望新会话默认进入 Architect，可在自己的 OpenCode 配置中设置：

```json
{
  "default_agent": "architect"
}
```

这属于本地运行偏好，不属于跨 harness 的组织模型。

## gstack 组合

角色定义主要回答 **WHO**，gstack 主要回答 **HOW**。

| 工作 | 默认承担者 | 可组合 Skill |
|---|---|---|
| 系统级架构设计 | Architect | `arch-director` |
| 工程计划复核 | Architect | gstack `plan-eng-review`, `autoplan` |
| Root Cause 调查 | Investigator | gstack `investigate` |
| 代码实现 | Programmer | 必要时 `investigate` |
| 工程代码 Review | 按 Architect 编排 | gstack `review` |
| UI 边验收边修复 | Programmer | gstack `qa` |
| UI 独立验收 | Investigator | gstack `qa-only` |
| 视觉检查 | Investigator / Programmer | gstack `design-review` |
| 安全专项 | 按 Architect 委派 | gstack `cso` |
| 发布前 gate | Architect 编排 | gstack `ship` |
| 上线后检查 | 按发布流程 | gstack `canary` |
| 独立模型意见 | Architect 按需 | 当前 harness 可用 outside-review Skill |

Skill 名称以当前环境实际发现结果为准；gstack 可能以 `gstack-*` 前缀暴露。

`agent-se-org` 不 vendor / fork gstack。

## Task Contract

Agent 间的非平凡委派使用轻量 Task Contract：

```text
Goal
Context
Scope
Non-goals
Constraints / Invariants
Required Evidence
Acceptance Criteria
```

模板：

```text
shared/skills/arch-director/templates/task-contract.md
```

Task Contract 是 Agent 间的消息契约，不是 Agent、Skill 或 workflow runtime。

## 内容分层

| 层 | 目录 | 权威内容 | 跨 harness |
|---|---|---|:---:|
| Organization Rules | `shared/AGENTS.md` | 全局协作规范与工程底线 | ✓ |
| Agent Roles | `agents/` | Architect / Investigator / Programmer 正文 | ✓ |
| Shared Skills | `shared/skills/` | arch-director 等跨平台方法与模板 | ✓ |
| Harness Adapter | `harness/<name>/` | mode / model / tools / 平台格式 | ✗ |
| Deployment Image | `dist/<name>/` | 构建生成的部署镜像 | generated |

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
          ...
          task-contract.md

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

## OpenCode 构建与部署

```bash
./build.sh
git diff dist/

cp -r ~/.config/opencode ~/.config/opencode.bak
cp -R dist/opencode/ ~/.config/opencode/
```

`build.sh` 会把 `harness/opencode/frontmatter/<agent>.md` 与 `agents/<agent>.md` 合成为最终 Agent 文件，因此新增 `architect` 后不需要额外修改构建逻辑。

最终部署内容仍然只使用 OpenCode 原生概念：

```text
AGENTS.md
agents/
skills/
```

## gstack 安装

gstack 单独安装：

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack

./setup --host opencode
# 或
./setup --host codex
```

OpenCode 与 Codex 的实际 Skill 名称和能力以当前 gstack 版本为准。

## 默认协作路径

```text
User Goal
  ↓
Architect 恢复项目状态
  ↓
事实不清？ ──→ Investigator
  ↓
Architect 做技术 / 架构决策
  ↓
需要深度架构方法？ ──→ arch-director
  ↓
复杂计划？ ──→ gstack plan review
  ↓
Task Contract
  ↓
Programmer 实现、自验证
  ↓
按风险选择 review / QA / security / outside review
  ↓
Architect 最终 Verdict
```

这不是固定工作流。简单任务应压缩；高风险、跨模块、事实不清或架构性任务才增加更多 gate。

## 设计原则

1. **Role 与 Skill 分离**：角色是责任主体，Skill 是按需能力。
2. **Architect 是正式 Primary Role**：不是“默认 Primary + Skill”的隐式组合。
3. **Architect 与 arch-director 分离**：日常编排属于 Agent，深度架构方法属于 Skill。
4. **Organization 与 Methodology 分离**：本仓库定义组织；gstack 提供通用工程方法。
5. **Architect 持有最终技术决策权**：worker 可以挑战设计，但不能静默改变架构。
6. **Investigator 与 Programmer 分工**：调查/独立验证与正式实现尽量分离。
7. **证据驱动**：Programmer 的“已完成”不是最终 Verdict。
8. **Harness-neutral source**：平台差异留在 `harness/`。
9. **不提前引入 workflow runtime**：暂不增加 task database、scheduler、queue 等新 primitive。

## 后续方向

### Codex adapter

增加 `harness/codex/`，研究 Codex 当前的 primary / subagent / skill 表达方式，并映射同一套 Role 模型。

### 默认 Agent 策略

OpenCode 支持 `default_agent`，但是否将 Architect 设为全局默认属于用户运行偏好。后续可以提供可选配置片段，而不是直接覆盖现有 `opencode.json`。

### 真实运行验证

用真实项目验证：

- Architect 是否出现在主 Agent 切换列表；
- Architect 是否能调用 Investigator / Programmer；
- Architect 与 worker 是否能发现已安装 gstack Skills；
- `arch-director` 是否只在架构任务中按需加载；
- Task Contract 是否足以稳定约束 worker；
- Review loop 是否能正确返回 Architect。
