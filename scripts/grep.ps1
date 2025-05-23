function grep {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Pattern,
        
        [Parameter(ValueFromPipeline=$true, ValueFromRemainingArguments=$true)]
        [string[]]$Path,
        
        [switch]$i,  # Case insensitive
        [switch]$v,  # Invert match
        [switch]$n,  # Show line numbers
        [switch]$c,  # Count matches only
        [switch]$l,  # List filenames only
        [switch]$r   # Recursive search
    )

    begin {
        $inputFromPipeline = @()
        $caseOption = if ($i) { 'IgnoreCase' } else { 'None' }
    }

    process {
        if ($_ -ne $null) {
            $inputFromPipeline += $_
        }
    }

    end {
        # Handle pipeline input
        if ($inputFromPipeline.Count -gt 0 -and $Path.Count -eq 0) {
            $lineNumber = 0
            $matchCount = 0
            
            foreach ($line in $inputFromPipeline) {
                $lineNumber++
                $isMatch = $line -match $Pattern
                
                if ($v) { $isMatch = -not $isMatch }
                
                if ($isMatch) {
                    $matchCount++
                    if (-not $c) {
                        if ($n) {
                            Write-Host "${lineNumber}: $line"
                            Write-Output "${lineNumber}: $line"
                        } else {
                            Write-Host $line
                            Write-Output $line
                        }
                    }
                }
            }
            
            if ($c) {
                Write-Host $matchCount
                Write-Output $matchCount
            }
            return
        }

        # Handle file search
        $searchPaths = if ($Path.Count -eq 0) { @("*") } else { $Path }
        
        foreach ($searchPath in $searchPaths) {
            $items = if ($r) {
                Get-ChildItem -Path $searchPath -File -Recurse -ErrorAction SilentlyContinue
            } else {
                Get-ChildItem -Path $searchPath -File -ErrorAction SilentlyContinue
            }
            
            foreach ($item in $items) {
                $content = Get-Content $item.FullName -ErrorAction SilentlyContinue
                if ($null -eq $content) { continue }
                
                $lineNumber = 0
                $fileMatchCount = 0
                $fileHasMatch = $false
                
                foreach ($line in $content) {
                    $lineNumber++
                    $isMatch = if ($i) {
                        $line -match $Pattern
                    } else {
                        $line -cmatch $Pattern
                    }
                    
                    if ($v) { $isMatch = -not $isMatch }
                    
                    if ($isMatch) {
                        $fileMatchCount++
                        $fileHasMatch = $true
                        
                        if ($l) {
                            Write-Host $item.FullName
                            Write-Output $item.FullName
                            break
                        } elseif (-not $c) {
                            $output = if ($r -or $searchPaths.Count -gt 1) {
                                "${item}: "
                            } else {
                                ""
                            }
                            
                            if ($n) {
                                Write-Host "$output${lineNumber}: $line"
                                Write-Output "$output${lineNumber}: $line"
                            } else {
                                Write-Host "$output$line"
                                Write-Output "$output$line"
                            }
                        }
                    }
                }
                
                if ($c -and $fileHasMatch) {
                    if ($r -or $searchPaths.Count -gt 1) {
                        Write-Host "${item}: $fileMatchCount"
                        Write-Output "${item}: $fileMatchCount"
                    } else {
                        Write-Host $fileMatchCount
                        Write-Output $fileMatchCount
                    }
                }
            }
        }
    }
}
