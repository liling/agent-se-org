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
  ├── reusable-evidence
  └── gstack / other Skills
  ↓
Architect Verdict
```

基本分工：

```text
Architect          = 判断 + 架构 + 编排 + 最终验收
Investigator       = 最小充分调查 + 诊断 + 独立验证
Programmer         = 正式实现 + 定向测试 + 修复
arch-director      = 深度架构方法 Skill
reusable-evidence  = 项目级可复用证据维护 Skill
gstack             = 通用软件工程方法 Skills
```

## Architect 是 Organization Runtime

真正的组织运行规则集中在：

```text
agents/architect.md
```

`shared/AGENTS.md` 只是极薄 bootstrap：告诉环境优先从 Architect 开始，并声明项目自身更具体的规则优先。

这样 Investigator 和 Programmer 不需要加载大量与自身无关的组织编排规则。

## Workflow v2

默认不运行完整多 Agent 流程，而是先按风险选择 Path。

### FAST

适用于局部、低风险、已有明确设计的工作：

```text
Short Task Contract
→ Programmer
→ V0 / V1 targeted verification
→ DONE
```

默认不加入 Investigator、独立 Review、full test 或 live probe。

### STANDARD

适用于中等范围、有少量未知或有限 design delta 的任务：

```text
Architect
→ optional Investigator
→ Task Contract
→ Programmer
→ V1 / V2 verification
→ Evidence Review
```

### DEEP

仅用于核心架构、persistence、security、identity、lifecycle、transaction、versioning、migration、distributed semantics 或 production-critical change：

```text
Focused Investigation
→ Architecture Decision / ADR
→ Task Contract
→ Programmer
→ V3 / V4 verification
→ Independent Architecture Review
→ Stage Gate
```

核心原则：

> 同一个问题只深入思考一次；同一个事实只调查一次；同一个验证只执行到足以证明结论为止。

## Verification Levels

```text
V0 — Inspect
V1 — Targeted
V2 — Related Suite
V3 — Full Repository
V4 — Live / External
```

验证是 claim-driven 的：任何命令都应能回答“它在证明哪个尚未被证明的 claim？”

Full test 默认集中到 V3、Stage Gate 或 Release Gate，而不是每个 Task 都重复执行。

## Worker Roles

### Investigator

`agents/investigator.md` 只负责明确事实问题：

- 查找、调查、复现、诊断、root cause；
- 最小充分证据；
- 必要时独立验证未证明或高风险 claim；
- 不拥有系统级架构决策权；
- 默认不负责正式 Feature implementation。

默认调查预算：最多 5 个直接相关文件、3 轮定向搜索、1 个必要 probe；证据足够后停止。

### Programmer

`agents/programmer.md` 负责：

- 按 Task Contract 实现；
- 在 Architect 给出的约束空间内自主决定局部实现；
- 根据 V0–V4 执行最小必要验证；
- 复用仍有效的 Evidence；
- 不静默改变架构或扩大 Scope。

## Role 与 Skill

Agent 是责任主体，Skill 是可组合方法。

```text
Architect != arch-director
Architect != reusable-evidence

Architect          = Role / Organization Runtime
arch-director      = Architecture Methodology Skill
reusable-evidence  = Reusable Evidence Methodology Skill
```

常见组合：

| 工作 | 默认承担者 | 可组合 Skill |
|---|---|---|
| 系统级架构设计 | Architect | `arch-director` |
| 高成本事实晋升/复用 | Architect | `reusable-evidence` |
| Root Cause 调查 | Investigator | gstack `investigate` |
| 正式代码实现 | Programmer | 必要时 `investigate` |
| 工程代码 Review | Architect 编排 | gstack `review` |
| UI 边验收边修复 | Programmer | gstack `qa` |
| UI 独立验收 | Investigator | gstack `qa-only` |
| 安全专项 | 按 Architect 委派 | gstack `cso` |
| 发布前 gate | Architect 编排 | gstack `ship` |

Skill 名称以当前环境实际可见结果为准。

## Task Contract v2

Architect 向 worker 委派非平凡任务时优先明确：

```yaml
task:
  id:
  title:

workflow:
  FAST | STANDARD | DEEP

objective:
baseline:
known_facts:
unknowns:
architecture:
scope:
allowed_changes:
forbidden_changes:
non_goals:
acceptance_criteria:
verification:
  level: V0 | V1 | V2 | V3 | V4
  required:
  explicitly_not_required:
reusable_evidence:
review:
  required:
  reason:
stop_when:
owner_agent:
```

`explicitly_not_required` 用来明确阻止不必要的 full test、live probe 或重复独立验证。

模板：

```text
shared/skills/arch-director/templates/task-contract.md
```

## Reusable Evidence

绝大多数任务证据只在当前 Task / PR / Review 中有效，不进入长期知识库。

只有获取成本高、未来很可能再次使用、并且可以定义明确失效条件的事实，才由 Architect 通过 `reusable-evidence` Skill 判断是否晋升。

组织级方法和模板：

```text
shared/skills/reusable-evidence/
  SKILL.md
  templates/evidence.md
```

具体项目的 Evidence 实例默认提交到该项目自己的：

```text
docs/evidence/
```

例如：

```text
docs/evidence/auth0-dcr-strict.md
docs/evidence/assignment-terminal-reassign.md
```

长期 Evidence 是**带失效条件的工程事实缓存**，不是永久真理。复用前必须检查 baseline、`invalidated_by` 和外部环境是否仍成立。

普通 lint/typecheck/test PASS、临时日志、容易重新获得的局部事实不要晋升。

`docs/evidence/` 默认进入 Git，禁止保存 token、cookie、password、client secret、private key 或其他敏感原始数据。

## 文档责任

推荐区分：

```text
docs/designs/       Change / Feature Design：准备怎么改
docs/architecture/  长期系统架构事实
docs/decisions/     ADR：长期决策及原因
docs/evidence/      昂贵、可复用、带失效条件的工程事实
```

Design 实施并验证后，再把稳定事实同步到 architecture / ADR。历史 ADR 不应被静默重写。

## 内容分层

| 层 | 目录 | 权威内容 |
|---|---|---|
| Bootstrap | `shared/AGENTS.md` | 极薄入口提示 |
| Agent Roles | `agents/` | Architect / Investigator / Programmer |
| Shared Skills | `shared/skills/` | 方法与模板 |
| Harness Adapter | `harness/opencode/`, `harness/codex/` | bootstrap / mode / model / tools / 平台格式 |
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
      reusable-evidence/
        SKILL.md
        templates/
          evidence.md

  agents/
    architect.md
    investigator.md
    programmer.md

  harness/
    opencode/
      frontmatter/
    codex/
      bootstrap.md
      frontmatter/

  dist/
    opencode/
      AGENTS.md
      agents/
      skills/
    codex/
      AGENTS.md
      agents/
      skills/
```

## OpenCode

OpenCode adapter 将 Architect 定义为：

```yaml
mode: primary
```

如果希望新会话默认进入 Architect，可在用户自己的 OpenCode 配置中设置：

```json
{
  "default_agent": "architect"
}
```

本仓库不强制覆盖该用户偏好。

## Codex

Codex 没有 `mode: primary`：主会话始终是用户自己的 agent，无法替换。因此 Architect 被定义为一个普通的 Codex agent，需要时唤醒，不占用主 agent。

```text
User
  ↓
Codex 主 agent（保持空闲）
  ↓ spawn_agent(agent_type="architect")
Architect
  ├── investigator
  └── programmer
```

Codex adapter 生成：

```text
dist/codex/
  AGENTS.md          # 极薄 bootstrap：非平凡软工任务唤醒 architect
  agents/
    architect.toml
    investigator.toml
    programmer.toml
  skills/            # 与 shared/skills 一致
```

agent 正文与 OpenCode 共用 `agents/*.md`；Codex 仅额外提供 TOML 元数据（description / model / reasoning effort）。

| agent | model | reasoning effort |
|---|---|---|
| architect | gpt-6-luna | high |
| investigator | gpt-6-luna | low |
| programmer | gpt-6-luna | medium |

部署：

```bash
./build.sh
cp ~/.codex/AGENTS.md ~/.codex/AGENTS.md.bak   # 备份现有内容
cp dist/codex/AGENTS.md ~/.codex/AGENTS.md
cp -R dist/codex/agents/* ~/.codex/agents/
cp -R dist/codex/skills/* ~/.codex/skills/     # 按目录合并，保留 gstack/.system
```

注意：`~/.codex/AGENTS.md` 会被薄 bootstrap 替换；`~/.codex/skills/` 只做增量合并，不会删除其他技能。

## 构建与部署

```bash
./build.sh
find dist -type f | sort

cp -r ~/.config/opencode ~/.config/opencode.bak
cp -R dist/opencode/ ~/.config/opencode/
```

`build.sh` 会把 `harness/opencode/frontmatter/<agent>.md` 与 `agents/<agent>.md` 合成为最终 Agent 文件，同时复制 bootstrap 和 shared skills。

`dist/` 是构建产物，已被 git 忽略，不提交。

CI 会执行构建完整性校验：依次运行 `./build.sh`、`./build.sh opencode`、`./build.sh codex`，校验预期产物文件齐备，并用 `tomllib` 验证 `dist/codex/agents/*.toml` 合法且 `developer_instructions` 与 `agents/*.md` 逐字一致。

## gstack 安装

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack
./setup --host opencode
# 或
./setup --host codex
```

## 最终设计原则

1. **Architect owns organization runtime**。
2. **Global instructions 最小化**。
3. **Role 与 Skill 分离**。
4. **Worker 只承担自身角色视角**。
5. **FAST / STANDARD / DEEP 按风险路由**。
6. **V0–V4 验证与风险匹配**。
7. **Review evidence，而不是 reproduce everything**。
8. **Reusable Evidence 只保存高价值项目事实，不保存 task noise**。
9. **Harness-neutral source，dist 由 build 生成并受 drift check 保护**。
10. **达到 stop condition 后停止继续调查和验证**。
