# Module 13 Completion Report

## MCP Configuration
```json
{
  "servers": {
    "echo-windows": {
      "command": "powershell",
      "args": ["-ExecutionPolicy", "Bypass", "-File", "./path/to/mcp-echo.ps1"]
    },
    "jiraEpm": {
      "type": "stdio",
      "command": "${workspaceFolder}/.venv/Scripts/uvx.exe",
      "args": ["--from", "mcp-atlassian==0.23.1", "mcp-atlassian"],
      "env": {
        "JIRA_URL": "https://jiraeu.epam.com",
        "JIRA_PERSONAL_TOKEN": "${input:jira-personal-token}",
        "JIRA_PROJECTS_FILTER": "EPMCDMETST",
        "TOOLSETS": "default,jira_agile",
        "READ_ONLY_MODE": "true"
      }
    }
  },
  "inputs": [
    {
      "id": "jira-personal-token",
      "type": "promptString",
      "description": "Jira EPAM personal access token",
      "password": true
    }
  ]
}
```

## Configured Servers
- echo-windows
- jiraEpm

## MCP Tool Test
- Tool used: `mcp_echo-windows_echo`
- Output:
```text
Module 13 MCP tool test
```
