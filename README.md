# Claude Code 国内接入模板

把 Claude Code 指向兼容 Anthropic Messages 协议的网关，国内网络直连，不用改 Claude Code 本体。

仓库里是可直接复制的环境变量、`settings.json` 模板和排错表。

> 本仓库由 [HardysAPI](https://hardysapi.com/console?utm_source=github&utm_medium=repo&utm_campaign=claude-code-setup) 维护。你也可以用任何兼容 Anthropic 协议的网关，改掉 `ANTHROPIC_BASE_URL` 即可。

## 三步接入

1. 在网关控制台创建 API Key（`sk-` 开头），记下所属分组。
2. 设置两个环境变量：

```bash
export ANTHROPIC_BASE_URL="https://api.hardysapi.com"
export ANTHROPIC_AUTH_TOKEN="sk-你的密钥"
```

3. 新开终端，运行 `claude`，随便问一句。

Windows PowerShell：

```powershell
$env:ANTHROPIC_BASE_URL="https://api.hardysapi.com"
$env:ANTHROPIC_AUTH_TOKEN="sk-你的密钥"
claude
```

## 用 settings.json 固化配置

不想每次开终端都 export，可写入 `~/.claude/settings.json`（模板见 [`examples/claude-settings.json`](examples/claude-settings.json)）：

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.hardysapi.com",
    "ANTHROPIC_AUTH_TOKEN": "sk-你的密钥"
  }
}
```

⚠️ `ANTHROPIC_API_KEY` 与 `ANTHROPIC_AUTH_TOKEN` 同时存在可能冲突，只留一个。

## 一键脚本

```bash
# 只打印要执行的命令（默认）
bash scripts/setup.sh sk-你的密钥

# 确认无误后追加到 ~/.zshrc 或 ~/.bashrc
bash scripts/setup.sh sk-你的密钥 --write
```

Windows 见 [`scripts/setup.ps1`](scripts/setup.ps1)。

## 模型名

模型名必须和密钥所在分组支持的清单一致，以控制台价格页为准。常用的有：

| 模型 | 场景 |
|---|---|
| `claude-sonnet-5-5` | 日常主力 |
| `claude-opus-5-5` | 复杂任务 |
| `claude-fable-5-1` | 最新一代 |
| `claude-haiku-4-5` | 轻量、批量 |

## 常见报错

| 报错 | 原因 | 解法 |
|---|---|---|
| `401 API_KEY_REQUIRED` / `invalid token` | 密钥没带上或不完整 | 重设 `ANTHROPIC_AUTH_TOKEN` |
| `402` / `403 insufficient balance` | 余额不足 | 充值后立即生效 |
| `429` | 并发/频率超限 | 降并发，几秒后重试 |
| `404 model not found` | 分组不支持该模型 | 换分组或换模型 |
| `Model "xxx" isn't recognized` | 同上（Claude Code 的提示语） | `/model` 换成分组内的模型 |
| `503 No available channel` | 上游临时无渠道 | 重试，持续则查渠道状态 |

更细的排查步骤见 [`docs/troubleshooting.md`](docs/troubleshooting.md)。

## 计费说明（HardysAPI）

- 1 元 = 1 美元额度，按 token 扣费，最低充值 10 元。
- 价格公开可查：`https://hardysapi.com/api/pricing`。
- 注册：<https://hardysapi.com/console?utm_source=github&utm_medium=repo&utm_campaign=claude-code-setup>

## License

MIT
