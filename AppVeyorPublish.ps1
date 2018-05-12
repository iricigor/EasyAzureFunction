# only publish if commit message starts with !publish
if ($Env:APPVEYOR_REPO_COMMIT_MESSAGE -notmatch ', publish!$') {
    Write-Output "No publishing from AppVeyor, to automatically publish, finish commit message with ', publish!'"
    exit
}

# check if this version already exists
$ModuleName = 'EasyAzureFunction'

$Manifest = Test-ModuleManifest -Path (Join-Path . "$ModuleName.psd1")
$LocalVersion = $Manifest.Version.ToString()

$RemoteModule = Find-Module $ModuleName -Repository PSGallery
$RemoteVersion = $RemoteModule.Version.ToString()

if ($LocalVersion -eq $RemoteVersion) {
    Write-Warning "Module $ModuleName with version $LocalVersion already exists. Consider bumping version."
    exit
}

# bootstrap Nuget to 2.8.6
$PSGetProgramDataPath = Join-Path -Path $env:ProgramData -ChildPath 'Microsoft\Windows\PowerShell\PowerShellGet\'
$NuGetExeName = 'NuGet.exe'
$NuGetExeFilePath = Join-Path $PSGetProgramDataPath $NuGetExeName

if ((-not (Test-Path -Path $NuGetExeFilePath -PathType Leaf)) -and (-not (Test-Path -Path $PSGetProgramDataPath))) {
    New-Item -Path $PSGetProgramDataPath -ItemType Directory -Force
}
# Download the NuGet.exe from https://nuget.org/NuGet.exe
Invoke-WebRequest -Uri https://nuget.org/NuGet.exe -OutFile $NugetExeFilePath


# we proceed with publish
Write-Output "Publishing version $LocalVersion to PSGallery, currently published version is $RemoteVersion"
try {
    Publish-Module -Path . -Repository PSGallery -NuGetApiKey $env:MyPSGalleryAPIKey -ea Stop
    Write-Output "Module successfully published!"
} catch {
    Write-Output "Publishing failed: $_"
}