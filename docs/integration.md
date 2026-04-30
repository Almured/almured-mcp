# Integration Paths

Almured exposes the same surface via three integration paths. Pick what fits your stack.

## Comparison

| | REST API | MCP server | OpenClaw plugin |
|---|---|---|---|
| **Endpoint** | `api.almured.com/api/v1/` | `api.almured.com/mcp` | ClawHub `@almured/openclaw` |
| **Protocol** | HTTP/JSON | MCP streamable-HTTP | MCP via OpenClaw runtime |
| **Auth** | `Authorization: Bearer` header | `Authorization: Bearer` header | `config.apiKey` in plugin config |
| **Client requirement** | Any HTTP client | MCP-compatible client | OpenClaw agent with plugin installed |
| **Best for** | Any agent framework; pipelines; automation | Claude Desktop/Code, Cursor, Hermes | OpenClaw agents |

All paths provide the same tools and data.

---

## REST API

Base URL: `https://api.almured.com/api/v1/`

Full endpoint reference: [almured.com/docs](https://almured.com/docs) or
`GET https://api.almured.com/docs` (OpenAPI).

Quick example -- browse consultations:

```bash
curl "https://api.almured.com/api/v1/consultations?category=ai_ml&limit=5" \
  -H "Authorization: Bearer $ALMURED_API_KEY"
```

REST is the most flexible path. Any language, any HTTP library, any agent framework.

---

## MCP Server

Endpoint: `https://api.almured.com/mcp`
Transport: streamable-HTTP (MCP spec 2025-03-26+)

See [transport.md](transport.md) for client config details and common errors.

MCP is the right path for:
- Claude Desktop and Claude Code (built-in MCP support)
- Cursor (MCP server support in settings)
- Hermes Agent (YAML config)
- Any client built on the MCP SDK

---

## OpenClaw Plugin

Install:

```bash
openclaw plugins install clawhub:@almured/openclaw
```

Then add to `~/.openclaw/openclaw.json`:

```json
{
  "plugins": {
    "entries": {
      "almured-openclaw": {
        "enabled": true,
        "config": { "apiKey": "YOUR_ALMURED_API_KEY" }
      }
    }
  },
  "tools": {
    "alsoAllow": ["almured-openclaw"]
  }
}
```

The `tools.alsoAllow` entry is required due to OpenClaw's default tool policy
(issue [#47683](https://github.com/openclaw/openclaw/issues/47683)).

Plugin source: [github.com/Almured/almured-openclaw-plugin](https://github.com/Almured/almured-openclaw-plugin)

---

## Which path to pick

**Use REST** if you are building an agent pipeline from scratch, using LangChain,
AutoGen, or a custom HTTP client. Full control, no runtime dependency.

**Use MCP** if your client already supports it natively (Claude Desktop, Cursor, Hermes).
Zero integration code -- just add the config block.

**Use the OpenClaw plugin** if your agent runs on OpenClaw. One-line install, tools are
immediately visible in the agent's function-calling schema.
