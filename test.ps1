# Simple test script
Write-Host "Simple Test - Loading scripts..." -ForegroundColor Yellow

$FailureCount = 0

# 스크립트 로드
$scriptPath = Join-Path $PSScriptRoot "scripts"
Get-ChildItem "$scriptPath\*.ps1" | ForEach-Object {
    Write-Host "Loading $($_.Name)..." -NoNewline
    try {
        . $_.FullName
        Write-Host " [OK]" -ForegroundColor Green
    } catch {
        Write-Host " [FAILED]" -ForegroundColor Red
        $script:FailureCount++
    }
}

# 명령어 확인
Write-Host "`nChecking available commands:" -ForegroundColor Yellow
@('touch', 'grep', 'rm', 'which', 'tail', 'head', 'du', 'ln') | ForEach-Object {
    if (Get-Command $_ -ErrorAction SilentlyContinue) {
        Write-Host "  ✓ $_" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $_" -ForegroundColor Red
        $script:FailureCount++
    }
}

Write-Host "`nTesting actual command execution:" -ForegroundColor Yellow

# Temporary file/directory names
$testFile = Join-Path $PSScriptRoot "testfile.txt"
$testFile2 = Join-Path $PSScriptRoot "testfile2.txt"
$testLink = Join-Path $PSScriptRoot "testlink.txt"

# touch test
try {
    touch $testFile
    if (Test-Path $testFile) {
        Write-Host "  ✓ touch: file created successfully" -ForegroundColor Green
    } else {
        Write-Host "  ✗ touch: file creation failed" -ForegroundColor Red
        $script:FailureCount++
    }
} catch {
    Write-Host "  ✗ touch: error occurred ($_)." -ForegroundColor Red
    $script:FailureCount++
}

# echo to add content
"hello world`nsecond line" | Out-File -Encoding utf8 $testFile

# grep test
try {
    $grepResult = grep hello $testFile | Out-String
    if ($grepResult -like "*hello world*") {
        Write-Host "  ✓ grep: working properly" -ForegroundColor Green
    } else {
        Write-Host "  ✗ grep: unexpected result" -ForegroundColor Red
        $script:FailureCount++
    }
} catch {
    Write-Host "  ✗ grep: error occurred ($_)." -ForegroundColor Red
    $script:FailureCount++
}

# head test
try {
    $headResult = head -n 1 $testFile
    if ($headResult -match "hello world") {
        Write-Host "  ✓ head: working properly" -ForegroundColor Green
    } else {
        Write-Host "  ✗ head: unexpected result" -ForegroundColor Red
        $script:FailureCount++
    }
} catch {
    Write-Host "  ✗ head: error occurred ($_)." -ForegroundColor Red
    $script:FailureCount++
}

# tail test
try {
    $tailResult = tail -n 1 $testFile
    if ($tailResult -match "second line") {
        Write-Host "  ✓ tail: working properly" -ForegroundColor Green
    } else {
        Write-Host "  ✗ tail: unexpected result" -ForegroundColor Red
        $script:FailureCount++
    }
} catch {
    Write-Host "  ✗ tail: error occurred ($_)." -ForegroundColor Red
    $script:FailureCount++
}

# du test
try {
    $duResult = du $testFile | Out-String
    if ($duResult -match "testfile.txt") {
        Write-Host "  ✓ du: working properly" -ForegroundColor Green
    } else {
        Write-Host "  ✗ du: no result" -ForegroundColor Red
        $script:FailureCount++
    }
} catch {
    Write-Host "  ✗ du: error occurred ($_)." -ForegroundColor Red
    $script:FailureCount++
}

# ln test (symbolic link)
try {
    ln -s $testFile $testLink
    if (Test-Path $testLink) {
        Write-Host "  ✓ ln: symbolic link created successfully" -ForegroundColor Green
    } else {
        Write-Host "  ✗ ln: symbolic link creation failed" -ForegroundColor Red
        $script:FailureCount++
    }
} catch {
    Write-Host "  ✗ ln: error occurred ($_)." -ForegroundColor Red
    $script:FailureCount++
}

# which test
try {
    $whichResult = which touch | Out-String
    if ($whichResult -like "*touch*") {
        Write-Host "  ✓ which: working properly ($whichResult)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ which: no result" -ForegroundColor Red
        $script:FailureCount++
    }
} catch {
    Write-Host "  ✗ which: error occurred ($_)." -ForegroundColor Red
    $script:FailureCount++
}

# rm test
try {
    rm $testFile
    if (-not (Test-Path $testFile)) {
        Write-Host "  ✓ rm: file deleted successfully" -ForegroundColor Green
    } else {
        Write-Host "  ✗ rm: file deletion failed" -ForegroundColor Red
        $script:FailureCount++
    }
    if (Test-Path $testLink) { rm $testLink }
} catch {
    Write-Host "  ✗ rm: error occurred ($_)." -ForegroundColor Red
    $script:FailureCount++
}

Write-Host "`nCommand execution tests completed!" -ForegroundColor Green

Write-Host "`nTest Summary:" -ForegroundColor Yellow
if ($FailureCount -eq 0) {
    Write-Host "✓ All tests passed!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "✗ $FailureCount test(s) failed!" -ForegroundColor Red
    exit 1
}
