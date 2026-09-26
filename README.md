# Multi-Agent 协作机制演进源

三角色协作机制（Architect / Investigator / Programmer）的单一内容源，
通过构建脚本生成各 harness（agent 运行平台）的部署镜像。
当前支持 opencode，包含文档工件体系、迭代管理、UI 工作流。

## 内容分层模型

| 层 | 目录 | 权威内容 | 跨 harness |
|----|------|----------|:---:|
| 共享内容 | `shared/` | AGENTS.md 全局规范；skills/ 方法论与模板 | ✓ 直接复用 |
| agents 定义 | `agents/` | 角色正文（职责、边界、流程、返回格式），**无 frontmatter** | ✓ 单源 |
| harness 适配 | `harness/<name>/` | frontmatter（mode / model / tools / 委派描述）等平台格式 | ✗ 每平台一份 |
| 构建产物 | `dist/<name>/` | 完整部署镜像（git track，审阅对象） | 生成，勿手改 |

一条规则只有一个权威出处：改正文改 `agents/` 或 `shared/`，改平台格式改 `harness/`，改完必须 rebuild。

## 目录结构

```text
se/
  README.md
  build.sh                          # 合成脚本（bash，零依赖）
  shared/
    AGENTS.md                       # 全局协作规范（含 48/49/50 节）
    skills/arch-director/
      SKILL.md                      # 架构方法论
      templates/                    # 8 个项目文档模板
  agents/
    investigator.md                 # 统一正文
    programmer.md
  harness/
    opencode/frontmatter/
      investigator.md               # opencode 适配片段
      programmer.md
  dist/opencode/                    # 产物：部署镜像
    AGENTS.md
    agents/*.md
    skills/arch-director/...
```

## 构建与部署

```bash
./build.sh                          # 生成 dist/opencode/
git diff dist/                      # 审阅产物变化
# 部署（先备份）：
cp -r ~/.config/opencode ~/.config/opencode.bak
cp -R dist/opencode/ ~/.config/opencode/
```

> 去重依据：经实验验证，opencode 会将全局 AGENTS.md 注入所有 subagent 上下文，
> agent 正文中的重复规范已改为对全局章节的引用（AGENTS.md 第 34/35/36/45/50.4 节等）。

## 部署后需验证的事项

- [ ] investigator 浏览器工具：frontmatter 中 chrome-devtools 的启用 key
      需按实际 MCP server 注册名确认后取消注释（当前以注释保留，
      位于 `harness/opencode/frontmatter/investigator.md`）
- [ ] 用一个真实小项目走一个完整迭代，检验：
      Phase A 读文档恢复状态 → Phase D 登记 → Review Verdict 落盘 → 迭代结束回写 roadmap

## 增加 harness 平台（codex / pi 等）

1. 调研该平台的 agents 定义格式与部署路径，在 `harness/<name>/` 建适配片段；
2. `build.sh` 增加对应构建函数（正文与 shared 内容直接复用）；
3. 若该平台无法表达某机制（如无 subagent、无 skill 分发），在 `harness/<name>/`
   内以平台自身机制替代，**不得修改 shared/ 的内容**；
4. 共享内容的权威归属若需调整（如提升顶层 shared 索引），先决策并记录。

## 已知平台差异（演进记录）

- opencode：skill 目录携带 templates/（相对 base directory）；
  codex 无原生 skill 机制，届时 SKILL 的分发方式需单独决策。

## 范围外（后续可选任务）

- agent 正文子编号（14.1 / 23.1）的重排：留待未来大版本重写时统一处理
- 各平台 frontmatter 的浏览器工具 key 实际启用验证
