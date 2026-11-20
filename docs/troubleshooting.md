# 常见报错排查

## 先做最小验证

用 `curl` 直接打一次 Messages 接口，能区分是客户端配置问题还是账号/上游问题：

```bash
curl https://api.hardysapi.com/v1/messages \
  -H "x-api-key: sk-你的密钥" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-sonnet-5-5","max_tokens":32,"messages":[{"role":"user","content":"hi"}]}'
```

返回 `content` → 密钥、余额、模型都正常，问题在 Claude Code 配置。
仍然报错 → 按下面的错误码处理。

## 401 API_KEY_REQUIRED / invalid token

- `ANTHROPIC_AUTH_TOKEN` 没设置，或只设了 `ANTHROPIC_API_KEY`。
- 密钥复制不完整（少了 `sk-` 后面的字符）或带了空格。
- 终端没重开，环境变量没生效。
- `settings.json` 与环境变量同时配置，值不一致。

```bash
echo "$ANTHROPIC_BASE_URL"
echo "$ANTHROPIC_AUTH_TOKEN"
unset ANTHROPIC_API_KEY
```

## 402 / 403 insufficient balance

余额不足。充值后立即生效，不需要重建密钥。

## 429

Claude Code 会并行发多个请求，超出并发限制就返回 429。减少并行任务、等几秒重试；需要长期更高并发请联系网关客服。

## Model "xxx" isn't recognized

Claude Code 收到不认识的模型名时会提示：

```
Model "xxx" isn't recognized · context assumed to be 200k tokens
There's an issue with the selected model (xxx)
```

原因是当前密钥所在分组没有这个模型。用 `/model` 换成该分组支持的模型，或换一个包含目标模型的分组建 Key。

## 404 model not found

模型名不在该分组，或拼写了不存在的版本后缀。模型名从控制台价格页复制。

## 503 No available channel

上游该模型临时没有可用渠道，本地改配置无效。重试通常恢复；持续出现看渠道状态页或联系客服。

## 连接超时

```bash
curl -m 10 https://api.hardysapi.com/health
```

- 超时 → 换网络，或换等价域名 `https://hardysapi.com`。
- 正常但 Claude Code 失败 → 检查本地代理是否把请求转到了错误出口。
