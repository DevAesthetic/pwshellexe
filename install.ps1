# install.ps1 - Installer for pwshellexe
# Downloads pwshellexe.ps1, converts it to EXE, and adds to PATH for global use

$ErrorActionPreference = 'Stop'
$repoUrl = 'https://raw.githubusercontent.com/DevAesthetic/pwshellexe/main/pwshellexe.ps1'
$exeName = 'pwshellexe.exe'
$installDir = "$env:USERPROFILE\\.pwshellexe"
$exePath = Join-Path $installDir $exeName
$ps1Path = Join-Path $installDir 'pwshellexe.ps1'

# Create install dir if needed
if (-not (Test-Path $installDir)) { New-Item -ItemType Directory -Path $installDir | Out-Null }

Write-Host "Downloading latest pwshellexe.ps1..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $repoUrl -OutFile $ps1Path -UseBasicParsing

# Ensure ps2exe module
if (-not (Get-Module -ListAvailable -Name ps2exe)) {
    Install-Module -Name ps2exe -Scope CurrentUser -Force -AllowClobber
}
Import-Module ps2exe -Force

Write-Host "Converting pwshellexe.ps1 to EXE..." -ForegroundColor Cyan
ps2exe -inputFile $ps1Path -outputFile $exePath -noConsole

# Add install dir to user PATH if not already present
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable('Path', "$userPath;$installDir", 'User')
    Write-Host "Added $installDir to user PATH. You may need to restart your terminal." -ForegroundColor Green
}

Write-Host "Install complete! You can now run 'pwshellexe run' from any terminal." -ForegroundColor Green
