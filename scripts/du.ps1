function du {
    param (
        [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$Path = ".",
        
        [switch]$h,      # Human readable (KB, MB, GB)
        [switch]$s,      # Summary only
        [switch]$c,      # Show total
        [int]$d = -1     # Max depth (-1 = unlimited)
    )

    function Format-Size {
        param([long]$Size)
        
        if (-not $h) {
            return "{0,10} KB" -f [math]::Round($Size / 1KB, 2)
        }
        
        if ($Size -lt 1KB) {
            return "{0,10} B " -f $Size
        } elseif ($Size -lt 1MB) {
            return "{0,10} KB" -f [math]::Round($Size / 1KB, 2)
        } elseif ($Size -lt 1GB) {
            return "{0,10} MB" -f [math]::Round($Size / 1MB, 2)
        } else {
            return "{0,10} GB" -f [math]::Round($Size / 1GB, 2)
        }
    }

    function Get-DirectorySize {
        param(
            [string]$DirectoryPath,
            [int]$CurrentDepth = 0
        )
        
        $size = 0
        try {
            $items = Get-ChildItem -Path $DirectoryPath -Force -ErrorAction SilentlyContinue
            
            foreach ($item in $items) {
                if ($item.PSIsContainer) {
                    $size += (Get-DirectorySize -DirectoryPath $item.FullName -CurrentDepth ($CurrentDepth + 1))
                } else {
                    $size += $item.Length
                }
            }
        } catch {
            # Ignore inaccessible folders
        }
        
        return $size
    }

    $targetPath = Resolve-Path $Path -ErrorAction SilentlyContinue
    if (-not $targetPath) {
        Write-Error "Path not found: $Path"
        return
    }

    $totalSize = 0
    $results = @()

    if ($s) {
        # Summary only
        $size = Get-DirectorySize -DirectoryPath $targetPath
        $totalSize = $size
        Write-Host ("$(Format-Size $size)`t$targetPath")
        Write-Output ("$(Format-Size $size)`t$targetPath")
    } else {
        # Detailed view
        function Show-DirectorySize {
            param(
                [string]$DirectoryPath,
                [int]$CurrentDepth = 0,
                [string]$Indent = ""
            )
            
            if ($d -ne -1 -and $CurrentDepth -gt $d) {
                return
            }
            
            try {
                $items = Get-ChildItem -Path $DirectoryPath -Force -ErrorAction SilentlyContinue
                
                foreach ($item in $items) {
                    if ($item.PSIsContainer) {
                        $dirSize = Get-DirectorySize -DirectoryPath $item.FullName
                        $script:totalSize += $dirSize
                        Write-Host ("$(Format-Size $dirSize)`t$Indent$($item.Name)")
                        Write-Output ("$(Format-Size $dirSize)`t$Indent$($item.Name)")
                        
                        if ($CurrentDepth -lt $d -or $d -eq -1) {
                            Show-DirectorySize -DirectoryPath $item.FullName -CurrentDepth ($CurrentDepth + 1) -Indent "$Indent  "
                        }
                    } else {
                        $script:totalSize += $item.Length
                        if ($CurrentDepth -eq 0) {
                            Write-Host ("$(Format-Size $item.Length)`t$($item.Name)")
                            Write-Output ("$(Format-Size $item.Length)`t$($item.Name)")
                        }
                    }
                }
            } catch {
                # Ignore inaccessible folders
            }
        }
        
        Show-DirectorySize -DirectoryPath $targetPath
    }

    if ($c) {
        Write-Host ("-" * 50)
        Write-Output ("-" * 50)
        Write-Host ("$(Format-Size $totalSize)`tTotal")
        Write-Output ("$(Format-Size $totalSize)`tTotal")
    }
}
