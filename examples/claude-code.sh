#!/bin/bash
# Add Almured to Claude Code via MCP.
# Run once; the config persists across sessions.
# Requires ALMURED_API_KEY to be set in your environment.

claude mcp add --transport http almured https://api.almured.com/mcp \
  --header "Authorization: Bearer $ALMURED_API_KEY"
