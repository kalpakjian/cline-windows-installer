#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

# Cline CLI Windows Installer - Full Version
# Based on pi.dev/install.ps1 with all features
$ClinePackage = "cline"
$ClineCmd = "cline"
$NpmMinReleaseAgeArg = "--min-release-age=0"
$NodeMinimum = [version]"20.0.0"

$PiEsc = [char]27

function Write-InstallerTitle {
  Write-Host ""
  Write-Host "  Cline CLI Installer for Windows"
  Write-Host "  Full Version (based on pi.dev/install.ps1)"
  Write-Host ""
}

function Test-NodeVersionIsNewEnough {
  param([string]$Version)
  $normalized = $Version.TrimStart("v")
  $parsed = [version]$normalized
  return $parsed -ge $NodeMinimum
}

function Get-UserEnv {
  $path = (Get-ItemProperty -Path "HKCU:\Environment").Path
  return $path
}

function Set-UserEnv {
  param([string]$Value)
  Set-ItemProperty -Path "HKCU:\Environment" -Name Path -Value $Value
  $env:PATH = $Value + ";" + $env:PATH
}

function Add-UserPathEntry {
  param([string]$Entry, [switch]$Prepend)
  $path = Get-UserEnv
  $entries = $path.Split(";", [System.StringSplitOptions]::RemoveEmptyEntries)

  if ($entries -notcontains $Entry) {
    if ($Prepend) {
      $entries = @($Entry) + $entries
    } else {
      $entries = $entries + @($Entry)
    }
    Set-UserEnv ($entries -join ";")
  }
}

function Invoke-PreflightChecks {
  $status = 0

  $node = Get-Command node -ErrorAction SilentlyContinue
  if ($node) {
    $nodeVersion = (& node --version).Trim()
    if (-not (Test-NodeVersionIsNewEnough $nodeVersion)) {
      Write-Host "error: Cline CLI requires Node.js 20.0.0 or newer. Found $nodeVersion."
      $status = 1
    }
  } else {
    Write-Host "error: Node.js 20.0.0 or newer is required to install Cline CLI."
    $status = 1
  }

  if (-not (Get-Command npm.cmd -ErrorAction SilentlyContinue)) {
    Write-Host "error: npm is required to install Cline CLI."
    $status = 1
  }

  $script:ClinePreflightStatus = $status
}

function Get-WindowsArch {
  $arch = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment").PROCESSOR_ARCHITECTURE
  if ($arch -eq "AMD64") { return "x64" }
  if ($arch -eq "ARM64") { return "arm64" }
  Write-Host "Unsupported CPU architecture: $arch"
  exit 1
}

function Invoke-DownloadFile {
  param([string]$Url, [string]$OutFile)
  curl.exe "-#SfLo" $OutFile $Url
  if ($LASTEXITCODE -ne 0) {
    Invoke-RestMethod -Uri $Url -OutFile $OutFile
  }
}

function Install-NodeStandalone {
  $nodeArch = Get-WindowsArch
  $nodeDistBase = "https://nodejs.org/dist/latest-v20.x"
  $nodeBaseDir = Join-Path $env:LOCALAPPDATA "cline-node"
  $nodeTmpDir = Join-Path ([System.IO.Path]::GetTempPath()) "cline-node-$PID"

  Remove-Item $nodeTmpDir -Recurse -Force -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force -Path $nodeTmpDir, $nodeBaseDir | Out-Null

  $shasumsPath = Join-Path $nodeTmpDir "SHASUMS256.txt"
  Write-Host "Resolving Node.js binary for win-$nodeArch"
  Invoke-DownloadFile "$nodeDistBase/SHASUMS256.txt" $shasumsPath

  $nodeFile = Get-Content $shasumsPath | ForEach-Object {
    if ($_ -match "\s+(node-v.+-win-$nodeArch\.zip)$") { $Matches[1] }
  } | Select-Object -First 1

  if (-not $nodeFile) {
    Write-Host "No Node.js binary found for win-$nodeArch."
    exit 1
  }

  $zipPath = Join-Path $nodeTmpDir $nodeFile
  Write-Host "Downloading Node.js $($nodeFile -replace '\.zip$', '')"
  Invoke-DownloadFile "$nodeDistBase/$nodeFile" $zipPath

  Write-Host "Extracting Node.js to $nodeBaseDir"
  Expand-Archive $zipPath $nodeTmpDir -Force

  $extractedDir = Join-Path $nodeTmpDir ($nodeFile -replace "\.zip$", "")
  $currentDir = Join-Path $nodeBaseDir "current"
  Remove-Item $currentDir -Recurse -Force -ErrorAction SilentlyContinue
  Move-Item $extractedDir $currentDir -Force
  Remove-Item $nodeTmpDir -Recurse -Force

  Add-UserPathEntry $currentDir -Prepend
  Write-Host "Node.js installed at $currentDir"
}

function Install-NodeNpmInteractive {
  $answer = Read-Host "Cline CLI needs Node.js 20.0.0 or newer and npm. Install standalone Node.js now? [Y/n]"
  if ($answer -match "^(n|no)$") {
    Write-Host "Install Node.js 20.0.0 or newer and npm, then run this installer again."
    return $false
  }
  Write-Host ""
  Install-NodeStandalone
  Write-Host ""
  return $true
}

function Install-ClinePackage {
  Write-Host "Installing Cline CLI..."
  Write-Host ""
  npm.cmd install -g --ignore-scripts $NpmMinReleaseAgeArg --no-fund --no-audit $ClinePackage
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
  Write-Host "Cline CLI installed successfully."
}

function Invoke-ClineInstaller {
  Write-InstallerTitle

  $preflightOutput = Invoke-PreflightChecks
  if ($script:ClinePreflightStatus -ne 0) {
    if (-not (Install-NodeNpmInteractive)) {
      exit $script:ClinePreflightStatus
    }
    Invoke-PreflightChecks
    if ($script:ClinePreflightStatus -ne 0) {
      exit $script:ClinePreflightStatus
    }
  }

  Install-ClinePackage
  Write-Host ""
  Write-Host "Run it with: cline"
  Write-Host "Note: Cline CLI Windows support is currently in preview."
}

Invoke-ClineInstaller
