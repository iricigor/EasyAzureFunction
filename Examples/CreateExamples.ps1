$Path = Join-Path ([system.io.path]::GetTempPath()) 'EzAzF'
New-AzureFunctionCode -CommandName Get-Command,Get-Process,Get-Module,Write-Output -Path $Path -Invoke

$PC = 'function Hello([string]$Name="World"){"Hello $Name"}'
Invoke-Expression $PC
New-AzureFunctionCode  -CommandName Hello -PreCode $PC -Path (Join-Path $Path 'HW')