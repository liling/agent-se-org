# Multi-Agent 协作机制修订部署包

本仓库是对三角色协作机制（Architect / Investigator / Programmer）的修订与演进源，
按平台组织于 `platforms/`。当前支持 opencode，包含三块新增能力：
文档工件体系、迭代管理、UI 工作流。

## 多平台演进约定

- 每个平台一个 `platforms/<name>/` 目录，镜像该平台的部署目标路径结构；
- 平台目录只放该平台的格式适配（frontmatter、工具名、目标路径）；
- 跨平台共享的内容主体（三角色规范、模板）目前以 `platforms/opencode/` 为权威；
  引入第二个平台（codex / pi）时，共享内容的权威归属（提升 shared/ 或平台复制）
  必须先决策并记录，避免两处复制漂移。

## 目录结构与部署目标

| 本仓库文件 | 部署目标 | 修订摘要 |
|-----------|----------|----------|
| platforms/opencode/AGENTS.md | ~/.config/opencode/AGENTS.md | 8.1 决策清单 +2 项（UI）；新增第 48/49/50 节；第 5/6/7/14/38/39/41 节指针化（单角色内容收敛至 agent 文件） |
| platforms/opencode/agents/investigator.md | ~/.config/opencode/agents/investigator.md | 第 8/18/23/24/25 节引用化；新增 14.1 UI 独立验证（证据标准引用 50.4）；修复 write 权限矛盾；tools 注释说明浏览器工具 |
| platforms/opencode/agents/programmer.md | ~/.config/opencode/agents/programmer.md | 第 3/24/25/26/27 节引用化；新增 23.1 UI 任务（引用 50 节与 50.4）；tools 注释说明浏览器工具 |
| platforms/opencode/skills/arch-director/SKILL.md | ~/.config/opencode/skills/arch-director/SKILL.md | Review 清单 +第 13 项；流程更新；第八节标注为 AGENTS 16 的扩展；新增二十八 UI 节（证据标准引用 50.4）；第五节含 8 个模板引用 |
| platforms/opencode/skills/arch-director/templates/*.md | ~/.config/opencode/skills/arch-director/templates/（新建） | 8 个项目文档模板 |

## 部署步骤

> 去重依据：经实验验证，opencode 会将全局 AGENTS.md 注入所有 subagent 上下文，
> agent 文件中的重复内容已改为对全局章节的引用。

1. 备份现有文件：
   cp ~/.config/opencode/AGENTS.md ~/.config/opencode/AGENTS.md.bak
   cp -r ~/.config/opencode/agents ~/.config/opencode/agents.bak
   cp -r ~/.config/opencode/skills/arch-director ~/.config/opencode/skills/arch-director.bak
2. 审阅差异：diff 原文件与本目录对应文件
3. 拷贝：将 `platforms/opencode/` 目录内容复制到 `~/.config/opencode/`（含 skills/arch-director/templates/ 整个目录）
4. 验证（见下）

## 部署后需验证的事项

- [ ] investigator 浏览器工具：frontmatter 中 chrome-devtools 的启用 key
      需按实际 MCP server 注册名确认后取消注释（当前以注释保留）
- [ ] 用一个真实小项目走一个完整迭代，检验：
      Phase A 读文档恢复状态 → Phase D 登记 → Review Verdict 落盘 → 迭代结束回写 roadmap

## 本次范围外（后续可选任务）

- agent 文件子编号（14.1 / 23.1）的重排：当前作为插入节语义清晰，留待未来大版本重写时统一处理
- agent 文件 frontmatter 中浏览器工具 key 的实际启用（需部署后按 MCP 注册名验证）
