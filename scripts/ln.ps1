function ln {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Target,
        
        [Parameter(Mandatory=$true)]
        [string]$Link,
        
        [switch]$s,      # Symbolic link
        [switch]$f,      # Force (overwrite existing)
        [switch]$h       # Hard link
    )

    # Check target path
    $targetPath = Resolve-Path $Target -ErrorAction SilentlyContinue
    if (-not $targetPath) {
        Write-Error "Target not found: $Target"
        return
    }

    # Check if link already exists
    if (Test-Path $Link) {
        if ($f) {
            Remove-Item $Link -Force -Recurse
        } else {
            Write-Error "Link already exists: $Link. Use -f to force overwrite."
            return
        }
    }

    # Determine link type
    $isDirectory = (Get-Item $targetPath).PSIsContainer
    
    try {
        if ($s) {
            # Symbolic link
            if ($isDirectory) {
                New-Item -ItemType SymbolicLink -Path $Link -Target $targetPath -Force | Out-Null
            } else {
                New-Item -ItemType SymbolicLink -Path $Link -Target $targetPath -Force | Out-Null
            }
            Write-Host "Created symbolic link: $Link -> $targetPath" -ForegroundColor Green
        } elseif ($h) {
            # Hard link (files only)
            if ($isDirectory) {
                Write-Error "Cannot create hard link for directory"
                return
            }
            New-Item -ItemType HardLink -Path $Link -Target $targetPath -Force | Out-Null
            Write-Host "Created hard link: $Link -> $targetPath" -ForegroundColor Green
        } else {
            # Default: Junction (directory) or Hard link (file)
            if ($isDirectory) {
                New-Item -ItemType Junction -Path $Link -Target $targetPath -Force | Out-Null
                Write-Host "Created junction: $Link -> $targetPath" -ForegroundColor Green
            } else {
                New-Item -ItemType HardLink -Path $Link -Target $targetPath -Force | Out-Null
                Write-Host "Created hard link: $Link -> $targetPath" -ForegroundColor Green
            }
        }
    } catch {
        Write-Error "Failed to create link: $_"
        Write-Host "Note: Creating symbolic links may require administrator privileges" -ForegroundColor Yellow
    }
}
