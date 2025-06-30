# PS2EXE GUI Converter Script
# Enhanced UI/UX, removed signing, added execution policy step

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Select-PS1File {
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.Filter = "PowerShell Scripts (*.ps1)|*.ps1"
    $ofd.Title = "Select PowerShell Script to Convert"
    $ofd.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    $ofd.RestoreDirectory = $true
    if ($ofd.ShowDialog() -eq 'OK') { return $ofd.FileName } else { return $null }
}

function Select-OutputFolder {
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    $fbd.Description = "Select Output Directory for EXE"
    if ($fbd.ShowDialog() -eq 'OK') { return $fbd.SelectedPath } else { return $null }
}

# Step 1: Select script file
[System.Windows.Forms.Application]::EnableVisualStyles()
$ps1Path = Select-PS1File
if (-not $ps1Path) { [System.Windows.Forms.MessageBox]::Show('No script selected. Exiting.','Error','OK','Error'); exit }

# Step 2: Choose output directory
$desktop = [Environment]::GetFolderPath('Desktop')
$downloads = [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads')
$sameDir = Split-Path $ps1Path

$form = New-Object System.Windows.Forms.Form
$form.Text = "Select Output Directory"
$form.Size = New-Object System.Drawing.Size(470, 300)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.BackColor = [System.Drawing.Color]::White
$form.Icon = [System.Drawing.SystemIcons]::Information

$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Choose where to save your EXE:"
$lblTitle.Font = New-Object System.Drawing.Font('Segoe UI', 13, [System.Drawing.FontStyle]::Bold)
$lblTitle.Location = '25,18'
$lblTitle.Size = '420,32'
$lblTitle.ForeColor = [System.Drawing.Color]::FromArgb(0, 51, 102)
$form.Controls.Add($lblTitle)

$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = '20,60'
$groupBox.Size = '420,130'
$groupBox.Text = "Output Location"
$groupBox.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Regular)
$groupBox.ForeColor = [System.Drawing.Color]::FromArgb(0, 51, 102)
$form.Controls.Add($groupBox)

$rbDesktop = New-Object System.Windows.Forms.RadioButton
$rbDesktop.Text = "Desktop"
$rbDesktop.Location = '25,30'
$rbDesktop.Size = '120,28'
$rbDesktop.Checked = $true
$rbDesktop.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$groupBox.Controls.Add($rbDesktop)

$rbDownloads = New-Object System.Windows.Forms.RadioButton
$rbDownloads.Text = "Downloads"
$rbDownloads.Location = '25,60'
$rbDownloads.Size = '120,28'
$rbDownloads.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$groupBox.Controls.Add($rbDownloads)

$rbSame = New-Object System.Windows.Forms.RadioButton
$rbSame.Text = "Same Directory as Script"
$rbSame.Location = '25,90'
$rbSame.Size = '180,28'
$rbSame.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$groupBox.Controls.Add($rbSame)

$rbCustom = New-Object System.Windows.Forms.RadioButton
$rbCustom.Text = "Custom..."
$rbCustom.Location = '220,30'
$rbCustom.Size = '90,28'
$rbCustom.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$groupBox.Controls.Add($rbCustom)

$tbCustom = New-Object System.Windows.Forms.TextBox
$tbCustom.Location = '310,32'
$tbCustom.Size = '90,24'
$tbCustom.Enabled = $false
$tbCustom.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$groupBox.Controls.Add($tbCustom)

$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = "Browse..."
$btnBrowse.Location = '310,60'
$btnBrowse.Size = '90,26'
$btnBrowse.Enabled = $false
$btnBrowse.Font = New-Object System.Drawing.Font('Segoe UI', 9)
$groupBox.Controls.Add($btnBrowse)

$btnOK = New-Object System.Windows.Forms.Button
$btnOK.Text = "Continue"
$btnOK.Location = '185,210'
$btnOK.Size = '110,38'
$btnOK.BackColor = [System.Drawing.Color]::FromArgb(0,120,215)
$btnOK.ForeColor = 'White'
$btnOK.Font = New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnOK)

$rbCustom.Add_CheckedChanged({ $tbCustom.Enabled = $rbCustom.Checked; $btnBrowse.Enabled = $rbCustom.Checked })
$btnBrowse.Add_Click({ $sel = Select-OutputFolder; if ($sel) { $tbCustom.Text = $sel } })

$btnOK.Add_Click({ $form.DialogResult = [System.Windows.Forms.DialogResult]::OK; $form.Close() })
$form.AcceptButton = $btnOK
$form.Topmost = $true
$form.ShowDialog() | Out-Null

if ($rbDesktop.Checked) { $outDir = $desktop }
elseif ($rbDownloads.Checked) { $outDir = $downloads }
elseif ($rbSame.Checked) { $outDir = $sameDir }
elseif ($rbCustom.Checked) {
    $outDir = $tbCustom.Text
    if (-not (Test-Path $outDir)) {
        [System.Windows.Forms.MessageBox]::Show('Custom directory does not exist. Exiting.','Error','OK','Error'); exit
    }
}
else { [System.Windows.Forms.MessageBox]::Show('No output directory selected. Exiting.','Error','OK','Error'); exit }

# Step 3: Ask for EXE name
$exeName = [System.IO.Path]::GetFileNameWithoutExtension($ps1Path) + ".exe"
$inputBox = New-Object System.Windows.Forms.Form
$inputBox.Text = "EXE Name"
$inputBox.Size = '420,180'
$inputBox.StartPosition = "CenterScreen"
$inputBox.FormBorderStyle = 'FixedDialog'
$inputBox.MaximizeBox = $false
$inputBox.MinimizeBox = $false
$inputBox.BackColor = [System.Drawing.Color]::White
$inputBox.Icon = [System.Drawing.SystemIcons]::Application
$lbl = New-Object System.Windows.Forms.Label
$lbl.Text = "Enter EXE file name:"
$lbl.Location = '30,40'
$lbl.Size = '170,32'
$lbl.Font = New-Object System.Drawing.Font('Segoe UI', 12)
$lbl.ForeColor = [System.Drawing.Color]::FromArgb(0, 51, 102)
$inputBox.Controls.Add($lbl)
$tb = New-Object System.Windows.Forms.TextBox
$tb.Text = $exeName
$tb.Location = '200,42'
$tb.Size = '170,32'
$tb.Font = New-Object System.Drawing.Font('Segoe UI', 12)
$inputBox.Controls.Add($tb)
$okBtn = New-Object System.Windows.Forms.Button
$okBtn.Text = "Continue"
$okBtn.Location = '150,100'
$okBtn.Size = '120,38'
$okBtn.BackColor = [System.Drawing.Color]::FromArgb(0,120,215)
$okBtn.ForeColor = 'White'
$okBtn.Font = New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Bold)
$inputBox.Controls.Add($okBtn)
$okBtn.Add_Click({ $inputBox.DialogResult = [System.Windows.Forms.DialogResult]::OK; $inputBox.Close() })
$inputBox.AcceptButton = $okBtn
$inputBox.Topmost = $true
$inputBox.ShowDialog() | Out-Null
$exeName = $tb.Text
if (-not $exeName.EndsWith('.exe')) { $exeName += '.exe' }
$exePath = Join-Path $outDir $exeName

# Step 4: Ensure NuGet and PS2EXE
# (No admin required, works for current user)
if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}
if (-not (Get-Module -ListAvailable -Name ps2exe)) {
    Install-Module -Name ps2exe -Scope CurrentUser -Force -AllowClobber
}
Import-Module ps2exe -Force

# Step 5: Convert
$progressForm = New-Object System.Windows.Forms.Form
$progressForm.Text = "Converting..."
$progressForm.Size = '400,140'
$progressForm.StartPosition = "CenterScreen"
$progressForm.FormBorderStyle = 'FixedDialog'
$progressForm.MaximizeBox = $false
$progressForm.MinimizeBox = $false
$progressForm.BackColor = [System.Drawing.Color]::White
$progressForm.Icon = [System.Drawing.SystemIcons]::Information
$lblProgress = New-Object System.Windows.Forms.Label
$lblProgress.Text = "Converting script to EXE, please wait..."
$lblProgress.Location = '30,30'
$lblProgress.Size = '340,32'
$lblProgress.Font = New-Object System.Drawing.Font('Segoe UI', 11)
$lblProgress.ForeColor = [System.Drawing.Color]::FromArgb(0, 51, 102)
$progressForm.Controls.Add($lblProgress)
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Style = 'Marquee'
$progressBar.Location = '30,70'
$progressBar.Size = '340,22'
$progressForm.Controls.Add($progressBar)
$progressForm.Topmost = $true
$progressForm.Show()
[System.Windows.Forms.Application]::DoEvents()

try {
    ps2exe -inputFile $ps1Path -outputFile $exePath -noConsole
    $progressForm.Close()
    if (Test-Path $exePath) {
        # Set execution policy for current user to allow running EXEs
        Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
        [System.Windows.Forms.MessageBox]::Show("Success! EXE created at: $exePath`n\nPowerShell execution policy set to allow running this EXE (RemoteSigned).","Done",'OK','Information')
    } else {
        [System.Windows.Forms.MessageBox]::Show("Failed to create EXE.", "Error", 'OK', 'Error')
    }
} catch {
    $progressForm.Close()
    [System.Windows.Forms.MessageBox]::Show("Error: $_", "Error", 'OK', 'Error')
}
