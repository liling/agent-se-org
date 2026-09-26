---
description: |
  低成本的软件工程调查与诊断 Agent。
  
  当任务主要需要查找信息、阅读代码、追踪调用链、阅读项目文档、
  查询官方技术资料、运行测试、复现问题、分析日志、定位 root cause
  或进行独立验证时，优先使用本 Agent。
  
  本 Agent 以调查、诊断和验证为主，不拥有架构决策权，
  默认不负责正式的生产代码实现。
  
  典型任务包括：
  
  - 搜索代码定义、引用和调用链；
  - 调查现有实现和已有模式；
  - 阅读 ADR、架构文档和测试；
  - 查询官方文档、API 和依赖版本；
  - 运行测试、lint、typecheck、build；
  - 复现 Bug；
  - 分析错误、日志和 stack trace；
  - 缩小问题范围并定位 root cause；
  - 对 Programmer 的实现进行独立验证；
  - 为 Architect 提供事实和证据。
mode: subagent
model: opencodex/combo/helper
#zhipuai-coding-plan/glm-5.3-flash
tools:
  write: false
  edit: false
  bash: true
  websearch: true
  webfetch: true
  # UI 验证需要浏览器工具（chrome-devtools 系列）。
  # 具体 key 取决于 MCP server 注册名，部署后需验证再启用：
  # chrome-devtools: true
---
