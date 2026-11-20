# Claude Code setup template (Anthropic-compatible gateway)

Point Claude Code at any gateway that speaks the Anthropic Messages API. No changes to Claude Code itself.

## Three steps

```bash
export ANTHROPIC_BASE_URL="https://api.hardysapi.com"
export ANTHROPIC_AUTH_TOKEN="sk-your-key"
claude
```

Windows PowerShell:

```powershell
$env:ANTHROPIC_BASE_URL="https://api.hardysapi.com"
$env:ANTHROPIC_AUTH_TOKEN="sk-your-key"
claude
```

Or persist it in `~/.claude/settings.json`:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.hardysapi.com",
    "ANTHROPIC_AUTH_TOKEN": "sk-your-key"
  }
}
```

Do not set `ANTHROPIC_API_KEY` at the same time — it can conflict with `ANTHROPIC_AUTH_TOKEN`.

## Models

Use model names supported by the key's group (see the provider's pricing page). Common ones: `claude-sonnet-5-5`, `claude-opus-5-5`, `claude-fable-5-1`, `claude-haiku-4-5`.

## Errors

| Error | Cause | Fix |
|---|---|---|
| `401 API_KEY_REQUIRED` | missing/incomplete key | reset `ANTHROPIC_AUTH_TOKEN` |
| `402` / `403 insufficient balance` | no credit | top up |
| `429` | rate/concurrency limit | lower concurrency, retry |
| `404 model not found` | model not in group | switch group or model |
| `Model "xxx" isn't recognized` | same, surfaced by Claude Code | `/model` to a supported model |
| `503 No available channel` | upstream temporarily unavailable | retry |

Full guide: [`docs/troubleshooting.md`](docs/troubleshooting.md).

## Scripts

```bash
bash scripts/setup.sh sk-your-key          # print commands
bash scripts/setup.sh sk-your-key --write  # append to ~/.zshrc or ~/.bashrc
```

Windows: `.\scripts\setup.ps1 -Key sk-your-key [-Persist]`.

Maintained by [HardysAPI](https://hardysapi.com/console?utm_source=github&utm_medium=repo&utm_campaign=claude-code-setup). MIT License.
