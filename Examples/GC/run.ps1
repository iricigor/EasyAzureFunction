﻿# run.ps1 auto-generated by EasyAzureFunction module, https://github.com/iricigor/EasyAzureFunction, iricigor@gmail.com
'run.ps1 start'

# POST method: $req
$requestContent = Get-Content $req -Raw
try {
  $requestBody = $requestContent | ConvertFrom-Json
  $Failed = $false
  "Params (JSON): $($requestBody.PSObject.Properties.Name -join `",`")"
  $EzInvokeCommand = $requestBody.EzInvokeCommand
  $EzName = $requestBody.EzName
  $EzVerb = $requestBody.EzVerb
  $EzNoun = $requestBody.EzNoun
  $EzModule = $requestBody.EzModule
  $EzFullyQualifiedModule = $requestBody.EzFullyQualifiedModule
  $EzCommandType = $requestBody.EzCommandType
  $EzTotalCount = $requestBody.EzTotalCount
  $EzSyntax = $requestBody.EzSyntax
  $EzShowCommandInfo = $requestBody.EzShowCommandInfo
  $EzArgumentList = $requestBody.EzArgumentList
  $EzAll = $requestBody.EzAll
  $EzListImported = $requestBody.EzListImported
  $EzParameterName = $requestBody.EzParameterName
  $EzParameterType = $requestBody.EzParameterType
} catch {$Failed = $true}
if ($Failed) {
"Params (URLEncoded): $requestContent"
  $requestContent -split '&' | % {
    $v = $_ -split '='
    if ($v[1]) {Set-Variable -Name $v[0] -Value $v[1]}
  }
}

# prepare output, either default web-page or invoke command
if (!$EzInvokeCommand) {
  'show default web page'
  cd $EXECUTION_CONTEXT_FUNCTIONDIRECTORY
  $Output = Get-Content .\index.html -Raw
} else {
  'invoke command'
  try {
    $ParamsHash = @{}
    if ($EzName) {$ParamsHash.Add('Name',@($EzName -replace '%2C',',' -split ','))}
    if ($EzVerb) {$ParamsHash.Add('Verb',@($EzVerb -replace '%2C',',' -split ','))}
    if ($EzNoun) {$ParamsHash.Add('Noun',@($EzNoun -replace '%2C',',' -split ','))}
    if ($EzModule) {$ParamsHash.Add('Module',@($EzModule -replace '%2C',',' -split ','))}
    if ($EzFullyQualifiedModule) {$ParamsHash.Add('FullyQualifiedModule',@($EzFullyQualifiedModule -replace '%2C',',' -split ','))}
    if ($EzCommandType) {$ParamsHash.Add('CommandType',$EzCommandType)}
    if ($EzTotalCount) {$ParamsHash.Add('TotalCount',$EzTotalCount)}
    if ($EzSyntax) {$ParamsHash.Add('Syntax',$True)}
    if ($EzShowCommandInfo) {$ParamsHash.Add('ShowCommandInfo',$True)}
    if ($EzArgumentList) {$ParamsHash.Add('ArgumentList',@($EzArgumentList -replace '%2C',',' -split ','))}
    if ($EzAll) {$ParamsHash.Add('All',$True)}
    if ($EzListImported) {$ParamsHash.Add('ListImported',$True)}
    if ($EzParameterName) {$ParamsHash.Add('ParameterName',@($EzParameterName -replace '%2C',',' -split ','))}
    if ($EzParameterType) {$ParamsHash.Add('ParameterType',@($EzParameterType -replace '%2C',',' -split ','))}
    "Params: $($ParamsHash.Keys -join `",`")"
    $Output = Get-Command @ParamsHash | Out-String
    if ($Output) {$Color = 'white'}
    else {$Color = 'gray'; $Output = 'Command run successfully, but it returned no output'}
  } catch {
    $Output = $_
    $Color = 'red'
  }
  $Head = "<head><style>body {background-color: #012456; color: $Color;}</style><title>EasyAzureFunction - Get-Command running example</title></head>"
  $Back = '<p><a href="javascript:history.back()" style="color:yellow;">Go Back</a></p>'
  $Output = $Head + '<pre>' + $Output + $Back + '</pre>'
  $Output = $Output -replace "`n",'</br>'
}

# parse and send back output
$Output2 = [PSCustomObject]@{Status = 200; Body = '';  Headers = @{}}
$Output2.Headers.Add('content-type','text/html')
$Output2.Body = $Output -replace '"',"'"

Out-File -Encoding utf8 -FilePath $res -inputObject ($Output2 | ConvertTo-JSON)
