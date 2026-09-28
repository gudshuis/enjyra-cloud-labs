<#
.SYNOPSIS
    ENJYRA Cloud Labs — Windows download/tool verification.
#>
$ErrorActionPreference = 'Continue'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$FailCount = 0

function Write-Pass($msg) { Write-Host "PASS: $msg" }
function Write-Warn($msg) { Write-Host "WARNING: $msg" }
function Write-Fail($msg) { Write-Host "FAIL: $msg"; $script:FailCount++ }

Write-Host "== Checksums =="
$checksums = Join-Path $RepoRoot 'checksums.txt'
if (Test-Path $checksums) {
    $ok = $true
    Get-Content $checksums | ForEach-Object {
        if ($_ -match '^([0-9a-f]{64})\s+\*?(.+)$') {
            $expected = $Matches[1]
            $relPath = $Matches[2]
            $fullPath = Join-Path $RepoRoot $relPath
            if (-not (Test-Path $fullPath)) {
                Write-Fail "Missing file listed in checksums.txt: $relPath"
                $ok = $false
                return
            }
            $actual = (Get-FileHash -Algorithm SHA256 -Path $fullPath).Hash.ToLower()
            if ($actual -ne $expected) {
                Write-Fail "Checksum mismatch: $relPath"
                $ok = $false
            }
        }
    }
    if ($ok) { Write-Pass "All files match checksums.txt" }
    $fingerprint = (Get-FileHash -Algorithm SHA256 -Path $checksums).Hash.ToLower()
    Write-Host "Release fingerprint (SHA-256 of checksums.txt): $fingerprint"
} else {
    Write-Warn "checksums.txt not found - skipping integrity check"
}

Write-Host "== Tools =="
if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Pass "Docker found: $(docker --version)"
} else {
    Write-Fail "Docker not found. Install Docker Desktop: https://docs.docker.com/get-docker/"
}

docker compose version *> $null
if ($LASTEXITCODE -eq 0) {
    Write-Pass "Docker Compose plugin found"
} else {
    Write-Fail "Docker Compose plugin not found."
}

if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Pass "Git found: $(git --version)"
} else {
    Write-Fail "Git not found. Install: https://git-scm.com/install/windows"
}

if (Get-Command py -ErrorAction SilentlyContinue) {
    Write-Pass "Python launcher found: $(py --version)"
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Pass "Python found: $(python --version)"
} else {
    Write-Warn "Python not found on PATH (not required to run the labs themselves)"
}

if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Pass "VS Code CLI found"
} else {
    Write-Warn "VS Code 'code' command not on PATH - not required to run the labs."
}

Write-Host "== Launcher =="
$launcher = Join-Path $RepoRoot 'scripts\cloud-labs\enjyra-cloud-lab.ps1'
if (Test-Path $launcher) {
    Write-Pass "enjyra-cloud-lab.ps1 is present"
} else {
    Write-Fail "enjyra-cloud-lab.ps1 missing"
}

if ($FailCount -gt 0) {
    Write-Host ""
    Write-Host "Integrity: FAILED - see FAIL lines above."
    exit 1
}
Write-Host ""
Write-Host "Integrity: VERIFIED"
