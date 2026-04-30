# MCP Transport

Almured uses the **streamable-HTTP** transport (MCP spec 2025-03-26+).

## Endpoint

```
POST https://api.almured.com/mcp
```

All MCP requests are POST to this URL. The server uses Server-Sent Events (SSE) for
streaming responses on long-running tool calls. Clients that support streamable-HTTP
handle this transparently.

## Client configuration

Most MCP clients require you to explicitly set the transport type. Use `http` or
`streamable-http` depending on your client:

**Claude Desktop / Claude Code:**
```json
{
  "mcpServers": {
    "almured": {
      "url": "https://api.almured.com/mcp",
      "headers": {
        "Authorization": "Bearer YOUR_ALMURED_API_KEY"
      }
    }
  }
}
```

**Cursor:**
```json
{
  "mcpServers": {
    "almured": {
      "url": "https://api.almured.com/mcp",
      "type": "http",
      "headers": {
        "Authorization": "Bearer YOUR_ALMURED_API_KEY"
      }
    }
  }
}
```

See [examples/](../examples/) for all client configs.

## Common errors

### HTTP 406 -- Wrong transport

If your client defaults to the legacy SSE transport (common in older MCP SDK versions),
you will receive a 406 with a structured error:

```json
{
  "jsonrpc": "2.0",
  "error": {
    "code": -32600,
    "message": "Not Acceptable: ...",
    "data": {
      "transport": "streamable-http",
      "spec_version": "2025-03-26",
      "hint": "Set transport to streamable-http in your MCP client config",
      "docs_url": "https://almured.com/docs#mcp-transport"
    }
  }
}
```

**Fix:** Set `type: "http"` (Cursor), or ensure your client config does not default to SSE.
The `data.hint` field tells you exactly what to change.

### HTTP 401 -- Auth failed

A valid-format Bearer token that fails authentication returns 401 with:

```json
{
  "jsonrpc": "2.0",
  "error": {
    "code": -32001,
    "message": "Unauthorized",
    "data": {
      "hint": "Generate a new API key at https://almured.com/account.",
      "docs_url": "https://almured.com/docs#authentication"
    }
  }
}
```

## Token via query param (claude.ai web connectors)

Claude.ai web connectors cannot set arbitrary headers. Pass the API key as a query param:

```
https://api.almured.com/mcp?token=YOUR_ALMURED_API_KEY
```

The server URL-decodes the value and treats it identically to a Bearer header.
