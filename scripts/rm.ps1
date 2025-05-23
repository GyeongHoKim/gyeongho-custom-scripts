function rm {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    $recurse = $false
    $force = $false
    $paths = @()

    foreach ($arg in $Args) {
        switch ($arg) {
            '-r' { $recurse = $true }
            '-f' { $force = $true }
            '-rf' { $recurse = $true; $force = $true }
            '-fr' { $recurse = $true; $force = $true }
            default { $paths += $arg }
        }
    }

    foreach ($path in $paths) {
        if (Test-Path $path) {
            $params = @{}
            if ($recurse) { $params['Recurse'] = $true }
            if ($force) { $params['Force'] = $true }

            Remove-Item $path @params
        } else {
            Write-Warning "Path '$path' not found"
        }
    }
}
