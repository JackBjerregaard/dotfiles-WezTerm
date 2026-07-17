param(
    [string]$VolumeLabel = "T7"
)

$ErrorActionPreference = "Stop"

function Confirm-Action {
    param([string]$Prompt)
    $answer = Read-Host "$Prompt [y/N]"
    return $answer -in @("y", "Y", "yes", "YES")
}

function Get-HandleCommand {
    $cmd = Get-Command handle64.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    $cmd = Get-Command handle.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    return $null
}

$volume = Get-Volume -FileSystemLabel $VolumeLabel -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $volume) {
    throw "Could not find a mounted volume with label '$VolumeLabel'."
}

if (-not $volume.DriveLetter) {
    throw "Volume '$VolumeLabel' does not have a drive letter."
}

$drive = "$($volume.DriveLetter):"
$handle = Get-HandleCommand

if (-not $handle) {
    Write-Host "Windows does not include a reliable built-in command for listing open file handles by drive."
    Write-Host "Install Sysinternals Handle and make handle64.exe available on PATH, then rerun this script."
    Write-Host "Drive found: $drive ($VolumeLabel)"
    exit 2
}

Write-Host "Checking processes using: $drive\"
$handleOutput = & $handle -nobanner "$drive\" 2>$null

$processes = @()
foreach ($line in $handleOutput) {
    if ($line -match '^(?<name>.+?)\s+pid:\s+(?<pid>\d+)\s+type:') {
        $processes += [PSCustomObject]@{
            Name = $Matches.name.Trim()
            Id = [int]$Matches.pid
        }
    }
}

$processes = $processes | Sort-Object Id -Unique

if ($processes.Count -gt 0) {
    Write-Host "Processes with open handles on this disk:"
    $processes | Format-Table -AutoSize Id, Name

    if (Confirm-Action "Force close these processes and eject '$VolumeLabel'?") {
        foreach ($process in $processes) {
            Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
        }
        Start-Sleep -Seconds 1
    } else {
        Write-Host "Not closing processes or ejecting."
        exit 1
    }
} else {
    Write-Host "No open handles found."
    if (-not (Confirm-Action "Eject '$VolumeLabel'?")) {
        Write-Host "Not ejecting."
        exit 1
    }
}

$shell = New-Object -ComObject Shell.Application
$driveItem = $shell.Namespace(17).ParseName("$drive\")
if (-not $driveItem) {
    throw "Could not resolve drive item for $drive."
}

Write-Host "Ejecting: $drive ($VolumeLabel)"
$driveItem.InvokeVerb("Eject")
