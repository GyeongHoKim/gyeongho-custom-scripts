function tail {
    param (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Path,
        
        [int]$n = 10,      # Number of lines to show
        [switch]$f,        # Follow mode (real-time monitoring)
        [switch]$Wait      # PowerShell's -Wait option support
    )

    process {
        if (-not $Path) {
            Write-Error "Please specify a file path"
            return
        }

        if (-not (Test-Path $Path)) {
            Write-Error "File not found: $Path"
            return
        }

        if ($f -or $Wait) {
            # Follow mode
            Get-Content $Path -Tail $n -Wait
        } else {
            # Normal mode
            Get-Content $Path -Tail $n
        }
    }
}

# Also add head command
function head {
    param (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Path,
        
        [int]$n = 10      # Number of lines to show
    )

    process {
        if (-not $Path) {
            Write-Error "Please specify a file path"
            return
        }

        if (-not (Test-Path $Path)) {
            Write-Error "File not found: $Path"
            return
        }

        Get-Content $Path -TotalCount $n
    }
}
