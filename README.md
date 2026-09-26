# Multi-Agent 软件工程组织演进源

三角色协作机制（Architect / Investigator / Programmer）的单一内容源，
通过构建脚本生成各 harness（Agent 运行平台）的部署镜像。

当前支持 OpenCode，包含：

- 全局协作规范；
- Architect / Investigator / Programmer 三角色模型；
- arch-director 架构方法论；
- 文档工件与模板；
- Task Contract；
- Iteration Protocol；
- Review Gate；
- UI 工作流；
- harness 适配与部署镜像。

本仓库的目标不是维护若干独立 Prompt，而是逐步形成一个可移植的软件工程 Agent Organization Source of Truth。

## 组织模型

```text
                         User
                           │
                           ▼
                  Architect / Primary
                  （Primary Role）
                    /            \
                   /              \
                  ▼                ▼
          Investigator          Programmer
          调查 / 诊断           实现 / 修改
          验证 / 取证           测试 / 修复
                   \              /
                    \            /
                     ▼          ▼
                    Review Gate
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
        PASS      NEEDS_CHANGES       BLOCKED
          │              │              │
          ▼              └──返工────────┘
        DONE
```

Architect 当前不是独立 subagent：Primary Agent 通过全局规范与 `arch-director` Skill 承担 Architect / Technical Lead 职责；Investigator 和 Programmer 是 specialized worker roles。

## 内容分层模型

| 层 | 目录 | 权威内容 | 跨 harness |
|----|------|----------|:---:|
| 组织规范 | `shared/AGENTS.md` | 全局原则、权责边界、通用工程纪律 | ✓ |
| 协作协议 | `shared/protocols/` | Task Contract、状态流转、证据要求、Review Gate | ✓ |
| 方法论 | `shared/skills/` | Architect 方法论、模板与可复用 Skill | ✓ |
| Agent 定义 | `agents/` | 角色正文（职责、边界、行为、返回格式），无 frontmatter | ✓ |
| harness 适配 | `harness/<name>/` | mode / model / tools / 委派描述等平台格式 | ✗ |
| 构建产物 | `dist/<name>/` | 完整部署镜像，git track，供审阅与部署 | 生成 |

规则归属原则：

- 所有任务都必须遵守的原则 → `shared/AGENTS.md`；
- 多角色协作如何运行 → `shared/protocols/`；
- Architect 方法论和模板 → `shared/skills/`；
- 某个角色如何行动 → `agents/`；
- 某个平台如何表达角色与工具 → `harness/`。

一条规则只有一个权威出处。不要在多个层复制同一规则。

## 目录结构

```text
agent-se-org/
  README.md
  build.sh

  shared/
    AGENTS.md

    protocols/
      README.md
      task-contract.md
      iteration-protocol.md
      review-gate.md

    skills/
      arch-director/
        SKILL.md
        templates/

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
      protocols/
      agents/
      skills/
```

## Task Contract

复杂任务不应只通过一段模糊自然语言委派。

`shared/protocols/task-contract.md` 定义标准协作接口：

```text
Goal
Context
Constraints
Allowed / Forbidden Scope
Required Evidence
Expected Artifact
Completion Criteria
Escalation Conditions
```

简单、局部、低风险任务可以压缩为：

```text
Goal
Scope
Constraints
Evidence
Done When
```

关键不是格式，而是减少隐藏上下文、静默扩大 scope 和“Agent 认为自己做完了”的问题。

## Iteration Protocol

默认状态流：

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

这目前是组织协议，不是工作流引擎。简单任务可以压缩阶段；复杂或高风险任务应显式执行完整 Contract、Verification 和 Review Gate。

## Review Gate

Architect 最终只给出三种 Verdict：

- `PASS`
- `NEEDS_CHANGES`
- `BLOCKED`

PASS 必须基于 Goal、Contract、实际 diff 和验证证据，不能只根据 Programmer 的总结。

推荐证据优先级：

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

## 构建与部署

```bash
./build.sh

git diff dist/

# 部署前建议备份
cp -r ~/.config/opencode ~/.config/opencode.bak
cp -R dist/opencode/ ~/.config/opencode/
```

`build.sh` 当前会把以下共享内容放入 OpenCode 部署镜像：

- `AGENTS.md`
- `skills/`
- `protocols/`
- 合成后的 `agents/*.md`

> 已实验确认 OpenCode 会将全局 AGENTS.md 注入 subagent 上下文，因此 Agent 正文尽量引用共享规则，而不是重复复制。

## v2 第一阶段边界

本阶段只建立稳定、跨 harness 的组织协议层，不引入新的 Runtime Primitive。

明确不做：

- 任务数据库；
- 工作流引擎；
- Agent queue；
- 自动调度；
- 并发控制；
- 自动审批；
- 自动 retry；
- 新增大量角色。

真实项目运行一段时间后，再决定哪些协议值得机器化。

## 部署后需验证

- [ ] 运行 `./build.sh`，确认 `dist/opencode/protocols/` 与 `shared/protocols/` 一致；
- [ ] Investigator 浏览器工具的实际 MCP key 验证并启用；
- [ ] 用真实小项目完整走一次：
      Intake → Investigation → Decision → Contract → Implementation → Verification → Review；
- [ ] 验证 `NEEDS_CHANGES` 能正确返回实现或调查阶段，而不是直接结束；
- [ ] 验证 Review Verdict 能落盘并在下一次会话恢复；
- [ ] 迭代结束后只回写长期有价值的信息到 roadmap / ADR / architecture docs。

## 增加 harness 平台（Codex / Pi 等）

1. 调研平台的 Agent 定义格式与部署路径，在 `harness/<name>/` 建适配层；
2. `build.sh` 增加对应构建函数；
3. `shared/` 与 `agents/` 的语义内容直接复用；
4. 若平台无法表达某机制，在 harness adapter 中使用平台原生机制替代；
5. 不得为了适配单个平台去污染 shared 层语义。

## 已知平台差异

- OpenCode：Skill 目录可携带 templates；支持 subagent frontmatter；
- Codex：具体 Skill / agent 分发与工具权限映射仍需单独设计并验证。

## 后续候选方向

只有在真实迭代证明有价值后再考虑：

- 将 Task Contract 结构化为机器可读 schema；
- iteration state 持久化；
- workflow runner；
- 自动 Review loop；
- Architect → Investigator → Programmer → Review 的自动调度；
- stable section anchors，替代对 AGENTS.md 章节编号的脆弱引用；
- Codex harness adapter；
- Agent 配置静态校验器。
