<#
.SYNOPSIS
    ENJYRA Cloud Labs — Windows PowerShell launcher. Does not require WSL.
.EXAMPLE
    .\scripts\cloud-labs\enjyra-cloud-lab.ps1 aws start
.EXAMPLE
    .\scripts\cloud-labs\enjyra-cloud-lab.ps1 azure status
#>
param(
    [Parameter(Mandatory = $true, Position = 0)][ValidateSet('aws', 'azure', 'gcp')][string]$Provider,
    [Parameter(Mandatory = $true, Position = 1)][ValidateSet('start', 'status', 'cli', 'reset', 'logs', 'stop')][string]$Action,
    [Parameter(Position = 2, ValueFromRemainingArguments = $true)][string[]]$CliArgs
)

$ErrorActionPreference = 'Stop'
$LauncherName = '.\scripts\cloud-labs\enjyra-cloud-lab.ps1'
$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$ComposeDir = Join-Path $RepoRoot 'compose'
$ComposeFile = Join-Path $ComposeDir "$Provider.compose.yml"

if (-not (Test-Path $ComposeFile)) {
    Write-Error "Could not find $ComposeFile - is this a complete enjyra-cloud-labs checkout?"
    exit 1
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker was not found on PATH. Install Docker Desktop: https://docs.docker.com/get-docker/"
    exit 1
}
docker info *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker is installed but not reachable. Start Docker Desktop, then try again."
    exit 1
}
docker compose version *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Error "The 'docker compose' plugin is not available. It ships with current Docker Desktop installs."
    exit 1
}

switch ($Provider) {
    'aws'   { $Port = 8081; $Project = 'enjyra-b01' }
    'azure' { $Port = 8082; $Project = 'enjyra-b02' }
    'gcp'   { $Port = 8083; $Project = 'enjyra-b03' }
}

function Invoke-Compose {
    param([string[]]$ComposeArgs)
    Push-Location $ComposeDir
    try {
        & docker compose -p $Project -f $ComposeFile @ComposeArgs
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    } finally {
        Pop-Location
    }
}

switch ($Action) {
    'start' {
        Invoke-Compose @('up', '-d', 'emulator', 'console')
        Write-Host "ENJYRA $Provider local lab is starting."
        Write-Host "Console: http://localhost:$Port"
        Write-Host "Status:  $LauncherName $Provider status"
    }
    'status' {
        Invoke-Compose @('ps')
    }
    'cli' {
        if (-not $CliArgs -or $CliArgs.Count -eq 0) {
            Write-Error "Usage: $LauncherName $Provider cli <command...>"
            exit 2
        }
        Invoke-Compose (@('--profile', 'tools', 'run', '--rm', 'cli') + $CliArgs)
    }
    'reset' {
        $pythonSnippet = "import urllib.request; request=urllib.request.Request('http://127.0.0.1:8080/api/reset', data=b'{}', headers={'Content-Type':'application/json'}, method='POST'); print(urllib.request.urlopen(request, timeout=30).read().decode())"
        Invoke-Compose @('exec', '-T', 'console', 'python', '-c', $pythonSnippet)
        Write-Host "Only the $Provider lesson resources were reset."
    }
    'logs' {
        Invoke-Compose @('logs', '--tail=120', 'emulator', 'console')
    }
    'stop' {
        Invoke-Compose @('down')
        Write-Host "ENJYRA $Provider local lab stopped. Its lesson-scoped volume is preserved for the next start."
    }
}
