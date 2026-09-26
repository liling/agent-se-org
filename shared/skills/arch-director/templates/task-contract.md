# Task Contract

> 用于 Architect 向 Investigator / Programmer 委派非平凡任务。只保留完成当前任务所需信息，不要复制全部项目上下文。

## Goal

要达成的可验证目标。

## Context

与本任务直接相关的背景、当前状态和已确认事实。

## Scope

允许调查或修改的范围。

## Non-goals

本任务明确不处理的事项。

## Constraints / Invariants

必须遵守的架构、兼容性、安全、数据、事务或项目约束。

## Required Evidence

完成后必须返回的证据，例如：

- actual diff / files changed
- targeted tests / integration tests
- lint / typecheck / build
- reproduction / root cause evidence
- screenshots / browser walkthrough
- benchmark / compatibility result

只要求与风险相匹配的证据，不机械要求全套。

## Acceptance Criteria

可以客观判断 PASS / NEEDS CHANGES 的完成条件。

---

## Optional: Design Decision

Architect 已经做出的、worker 不应自行改变的设计决策。

## Optional: Files / Modules to Inspect

建议优先检查的位置；不是禁止搜索其他相关位置。

## Optional: Implementation Requirements

只有真正影响 contract / behavior 的实现要求才写在这里，不规定无意义的局部细节。

## Optional: Reporting Requirements

特殊输出格式、需要落盘的报告或证据位置。
