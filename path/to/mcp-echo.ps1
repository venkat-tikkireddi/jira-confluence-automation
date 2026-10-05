$ErrorActionPreference = 'Stop'

while ($null -ne ($line = [Console]::In.ReadLine())) {
    try {
        $request = $line | ConvertFrom-Json -ErrorAction Stop

        if ($request.method -like 'notifications/*') {
            continue
        }

        $result = $null
        $errorObject = $null

        switch ($request.method) {
            'initialize' {
                $result = @{
                    protocolVersion = $request.params.protocolVersion
                    capabilities = @{ tools = @{} }
                    serverInfo = @{ name = 'echo-windows'; version = '1.0.0' }
                }
            }
            'ping' {
                $result = @{}
            }
            'tools/list' {
                $result = @{
                    tools = @(
                        @{
                            name = 'echo'
                            description = 'Returns the supplied message.'
                            inputSchema = @{
                                type = 'object'
                                properties = @{ message = @{ type = 'string' } }
                                required = @('message')
                            }
                        }
                    )
                }
            }
            'tools/call' {
                if ($request.params.name -ne 'echo') {
                    $result = @{
                        content = @(@{ type = 'text'; text = "Unknown tool: $($request.params.name)" })
                        isError = $true
                    }
                }
                else {
                    $message = [string]$request.params.arguments.message
                    $result = @{
                        content = @(@{ type = 'text'; text = $message })
                        isError = $false
                    }
                }
            }
            default {
                $errorObject = @{ code = -32601; message = "Method not found: $($request.method)" }
            }
        }

        if ($null -ne $errorObject) {
            $response = @{ jsonrpc = '2.0'; id = $request.id; error = $errorObject }
        }
        else {
            $response = @{ jsonrpc = '2.0'; id = $request.id; result = $result }
        }

        [Console]::Out.WriteLine(($response | ConvertTo-Json -Depth 20 -Compress))
    }
    catch {
        [Console]::Error.WriteLine($_.Exception.Message)
    }
}