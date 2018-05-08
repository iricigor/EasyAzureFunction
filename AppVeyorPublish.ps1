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
    throw "Module $ModuleName with version $LocalVersion already exists. Consider bumping version."
}

# we proceed with publish
Write-Output "Publishing version $LocalVersion to PSGallery, currently published version is $RemoteVersion"
Publish-Module -Path . -Repository PSGallery -NuGetApiKey $env:MyPSGalleryAPIKey