# Gyeongho Custom Scripts Installer
param(
    [switch]$Uninstall
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$profilePath = $PROFILE

if ($Uninstall) {
    Write-Host "Uninstalling Gyeongho Custom Scripts..." -ForegroundColor Yellow
    
    if (Test-Path $profilePath) {
        $content = Get-Content $profilePath -Raw
        $pattern = '# Gyeongho Custom Scripts Loader[\s\S]*?}\s*'
        $newContent = $content -replace $pattern, ''
        Set-Content $profilePath -Value $newContent.TrimEnd()
        Write-Host "Custom scripts have been removed from your PowerShell profile." -ForegroundColor Green
    }
} else {
    Write-Host "Installing Gyeongho Custom Scripts..." -ForegroundColor Yellow
    
    # PowerShell 프로필 생성 (없는 경우)
    if (!(Test-Path $profilePath)) {
        New-Item -Path $profilePath -ItemType File -Force | Out-Null
        Write-Host "Created PowerShell profile at: $profilePath" -ForegroundColor Green
    }
    
    # 스크립트 로더 추가
    $profileContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
    $loaderScript = @"

# Gyeongho Custom Scripts Loader
`$gyeonghoScriptsPath = "$scriptPath\scripts"
if (Test-Path `$gyeonghoScriptsPath) {
    Get-ChildItem "`$gyeonghoScriptsPath\*.ps1" | ForEach-Object {
        . `$_.FullName
    }
}
"@
    
    if ($profileContent -notmatch 'Gyeongho Custom Scripts Loader') {
        Add-Content $profilePath -Value $loaderScript
        Write-Host "Installation complete!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Available commands:" -ForegroundColor Cyan
        Get-ChildItem "$scriptPath\scripts\*.ps1" | ForEach-Object {
            $content = Get-Content $_.FullName -Raw
            if ($content -match 'function\s+(\w+)') {
                $matches[1..($matches.Count-1)] | ForEach-Object {
                    Write-Host "  - $_" -ForegroundColor White
                }
            }
        }
        Write-Host ""
        Write-Host "Please restart PowerShell or run the following command:" -ForegroundColor Yellow
        Write-Host "  . `$PROFILE" -ForegroundColor White
    } else {
        Write-Host "Gyeongho Custom Scripts is already installed." -ForegroundColor Yellow
    }
}
