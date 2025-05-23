function which {
    param (
        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
        [string[]]$Commands
    )

    foreach ($command in $Commands) {
        $result = Get-Command $command -ErrorAction SilentlyContinue
        
        if ($result) {
            switch ($result.CommandType) {
                'Application' {
                    Write-Host $result.Source
                    Write-Output $result.Source
                }
                'Cmdlet' {
                    Write-Host "Cmdlet: $($result.Name) from module $($result.ModuleName)"
                    Write-Output "Cmdlet: $($result.Name) from module $($result.ModuleName)"
                }
                'Function' {
                    Write-Host "Function: $($result.Name)"
                    Write-Output "Function: $($result.Name)"
                    if ($result.ScriptBlock) {
                        Write-Host "Defined in: $($result.ScriptBlock.File)"
                        Write-Output "Defined in: $($result.ScriptBlock.File)"
                    }
                }
                'Alias' {
                    Write-Host "Alias: $($result.Name) -> $($result.Definition)"
                    Write-Output "Alias: $($result.Name) -> $($result.Definition)"
                    # 재귀적으로 실제 명령어 찾기
                    which $result.Definition
                }
                default {
                    Write-Host "$($result.CommandType): $($result.Name)"
                    Write-Output "$($result.CommandType): $($result.Name)"
                }
            }
        } else {
            Write-Host "$command not found" -ForegroundColor Red
            Write-Output "$command not found"
        }
    }
}
