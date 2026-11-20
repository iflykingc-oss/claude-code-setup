#!/usr/bin/env bash
# 配置 Claude Code 使用兼容 Anthropic 协议的网关。
# 用法：
#   bash scripts/setup.sh sk-你的密钥          # 只打印命令
#   bash scripts/setup.sh sk-你的密钥 --write  # 追加到 shell 配置文件
set -euo pipefail

BASE_URL="${GATEWAY_URL:-https://api.hardysapi.com}"
KEY="${1:-}"
WRITE="${2:-}"

if [[ -z "$KEY" ]]; then
  echo "用法: bash scripts/setup.sh sk-你的密钥 [--write]" >&2
  exit 1
fi

if [[ "$KEY" != sk-* ]]; then
  echo "密钥应以 sk- 开头，请检查是否复制完整。" >&2
  exit 1
fi

BLOCK="# >>> claude-code-gateway >>>
export ANTHROPIC_BASE_URL=\"$BASE_URL\"
export ANTHROPIC_AUTH_TOKEN=\"$KEY\"
unset ANTHROPIC_API_KEY
# <<< claude-code-gateway <<<"

if [[ "$WRITE" != "--write" ]]; then
  echo "将写入以下内容："
  echo
  echo "$BLOCK"
  echo
  echo "确认无误后重新执行并加上 --write。"
  exit 0
fi

case "${SHELL:-}" in
  *zsh)  RC="$HOME/.zshrc" ;;
  *bash) RC="$HOME/.bashrc" ;;
  *)     RC="$HOME/.profile" ;;
esac

if grep -q "claude-code-gateway" "$RC" 2>/dev/null; then
  echo "$RC 里已有配置，未重复写入。如需更新请手动编辑。" >&2
  exit 1
fi

printf '\n%s\n' "$BLOCK" >> "$RC"
echo "已写入 $RC。执行 source $RC 或新开终端后运行 claude。"
