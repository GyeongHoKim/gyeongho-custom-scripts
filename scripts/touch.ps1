function touch {
    param (
        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
        [string[]]$Paths
    )

    foreach ($path in $Paths) {
        if (Test-Path $path) {
            # 파일이 존재하면 마지막 수정 시간 업데이트
            (Get-Item $path).LastWriteTime = Get-Date
        } else {
            # 파일이 없으면 빈 파일 생성
            New-Item -ItemType File -Path $path -Force | Out-Null
        }
    }
}
