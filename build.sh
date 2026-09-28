#!/usr/bin/env bash
# 从单一内容源生成各 harness 的部署镜像。
#
# 源:
#   shared/AGENTS.md            跨 harness 的极薄 bootstrap
#   shared/skills/              跨 harness 方法论 + 模板（直接取用）
#   agents/<name>.md            agents 统一定义正文（无 frontmatter）
#   harness/<h>/frontmatter/<name>.md   per-harness frontmatter 适配片段
#
# 产物:
#   dist/<h>/                   完整部署镜像（构建产物，git 忽略）
set -euo pipefail
cd "$(dirname "$0")"

build_opencode() {
  local out=dist/opencode
  rm -rf "$out"
  mkdir -p "$out/agents"

  cp shared/AGENTS.md "$out/AGENTS.md"
  cp -r shared/skills "$out/skills"

  for fm in harness/opencode/frontmatter/*.md; do
    local name
    name="$(basename "$fm" .md)"
    [ -f "agents/$name.md" ] || { echo "ERROR: agents/$name.md 不存在" >&2; exit 1; }
    cat "$fm" "agents/$name.md" > "$out/agents/$name.md"
  done
}

case "${1:-all}" in
  opencode) build_opencode ;;
  all)      build_opencode ;;
  *) echo "用法: $0 [opencode|all]" >&2; exit 1 ;;
esac

echo "build 完成:"
find dist -type f | sort
