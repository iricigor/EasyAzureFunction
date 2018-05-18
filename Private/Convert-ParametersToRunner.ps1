function Convert-ParametersToRunner {
    
    # Used to generate run.ps1 file which is executed in Azure Function

    param (
        
        [string]$Command,
        [string]$PreCode,
        [string]$PostCode,
        [switch]$Invoke,
        [switch]$Clipboard

    )

    BEGIN {
        $Response = @()
        $Response += "# run.ps1 auto-generated by EasyAzureFunction module, https://github.com/iricigor/EasyAzureFunction, iricigor@gmail.com","'run.ps1 start'"

        $Prefix = 'Ez'
    }

    PROCESS {

        foreach ($C1 in $Command) { # Initially $Command was an array

            Write-Verbose -Message "Processing command $C1"
            $Params = Get-Parameter $C1 

            # generate code to read parameters
            $Response += '', '# POST method: $req', '$requestContent = Get-Content $req -Raw'
            # try to properly parse json response
            $Response += 'try {','  $requestBody = $requestContent | ConvertFrom-Json','  $Failed = $false'
            $Response += '  "Params (JSON): $($requestBody.PSObject.Properties.Name -join `",`")"' # logging to AzF console
            $Response += "  `$$Prefix`InvokeCommand = `$requestBody.$Prefix`InvokeCommand" # reads hidden parameter
            foreach ($P1 in ($Params.Name | Select -Unique)) {$Response += "  `$$Prefix$P1 = `$requestBody.$Prefix$P1"}
            # if fails, try to parse URL encoded params
            $Response += '} catch {$Failed = $true}'
            $Response += 'if ($Failed) {', '"Params (URLEncoded): $requestContent"' # logging to AzF console
            $Response += "  `$requestContent -split '&' | % {","    `$v = `$_ -split '='"
            $Response += '    if ($v[1]) {Set-Variable -Name $v[0] -Value $v[1]}','  }','}'
            # FIXME: Above not good because any name gets converted to var

            # generate code to open default page
            $Response += '','# prepare output, either default web-page or invoke command','cd $EXECUTION_CONTEXT_FUNCTIONDIRECTORY'
            $Response += "if (!`$$Prefix`InvokeCommand) {","  'show default web page'", '  $Output = Get-Content .\index.html -Raw'

            # generate code to prepare parameters splatting
            $Response += '} else {',"  'invoke command'", '  try {'
            $Response += "    `$ParamsHash = @{}"
            $Response += "    `$CredentialArray = ''"
            foreach ($P1 in ($Params | Select -Unique Name, Type)) {
                $N = $P1.Name
                if ($P1.Type -eq 'SwitchParameter') {
                    $Response += "    if (`$$Prefix$N) {`$ParamsHash.Add('$N',`$True)}"
                } elseif ($P1.Type -match '\[]$') {
                    $Response += "    if (`$$Prefix$N) {`$ParamsHash.Add('$N',@(`$$Prefix$N -replace '%2C',',' -split ','))}"
                } elseif ($P1.Type -eq 'PSCredential') {
                    $Response += "    if (`$$Prefix$N`UserName -and `$$Prefix$N`Password) {"
                    # idea: generated code will look like: New-PSDrive @ParamsHash -Credential $EzCredential
                    # runner will generate new variable named like EzCredential containing credential
                    $Response += "      $Prefix$N`SecPass = ConvertTo-SecureString '`$$Prefix$N`Password' -AsPlainText -Force"
                    $Response += "      $Prefix$N = New-Object System.Management.Automation.PSCredential ('`$$Prefix$N`UserName', `$$Prefix$N`SecPass)"
                    # for invoking we will pass this part as string to code
                    $Response += "      `$CredentialArray += ' -$N `$$Prefix$N'" # append something like ' -Credential $EzCredential'
                } else {
                    $Response += "    if (`$$Prefix$N) {`$ParamsHash.Add('$N',`$$Prefix$N)}"
                }                
            }
            # run custom code
            if ($PreCode) {$Response += "    $PreCode | OutString"}
            # generate code to invoke command and handle output
            $Response += '    "Params: $($ParamsHash.Keys -join `",`")"' # logging to AzF console
            $Response += "    `$Output = $C1 @ParamsHash | Out-String"
            if ($PostCode) {$Response += "    $PostCode | OutString"}
            $Response += '    if ($Output) {$Color = ''white''}','    else {$Color = ''gray''; $Output = ''Command run successfully, but it returned no output''}'
            $Response += '  } catch {','    $Output = $_','    $Color = ''red''','  }'

            $Response += '  $Head = "<head><style>body {background-color: #012456; color: $Color;}</style><title>EasyAzureFunction - ' + $C1 + ' running example</title></head>"'
            $Response += '  $Back = ''<p><a href="javascript:history.back()" style="color:yellow;">Go Back</a></p>'''
            $Response += "  `$Output = `$Head + '<pre>' + `$Output + `$Back + '</pre>'"
            $Response += "  `$Output = `$Output -replace `"``n`",'</br>'",'}'
                        
            # convert output to HTML and parse it back
            $Response += '', '# parse and send back output'
            $Response += "`$Output2 = [PSCustomObject]@{Status = 200; Body = '';  Headers = @{}}","`$Output2.Headers.Add('content-type','text/html')"
            $Response += "`$Output2.Body = `$Output -replace '`"',`"'`""

            $Response += '','Out-File -Encoding utf8 -FilePath $res -inputObject ($Output2 | ConvertTo-JSON)'
        }
    }

    END {
        if ($Clipboard) {
            $Response | Set-Clipboard
        } elseif ($Invoke) {
            $TempFile = [System.IO.Path]::GetTempFileName() + '.txt'
            $Response | Out-File $TempFile
            Invoke-Item $TempFile
        } else {
            $Response
        }
    }
}