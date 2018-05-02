function Convert-ParametersToHTML () {
    
    # Used to generate index.html file which is presented if Azure Function is called without default parameter

    # Example: Get-Parameters Get-Location | Convert-ParametersToHTML -Boot -Invoke
    
    param (
        
        [string[]]$Command,
        [switch]$Invoke,
        [switch]$Bootstrap,
        [switch]$Clipboard

    )

    BEGIN {
        $Response = @()
        $Response += '<!DOCTYPE html>','<html lang="en">','<head>'
        # TODO: Add title tag
        if ($Bootstrap) {
            $Response += '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">'
            $Response += '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>'
            $Response += '<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>'
        }
        $Response += '</head>','<body>'
        if ($Bootstrap) {$Response += '<div class="container">'}
    }

    PROCESS {
        foreach ($C1 in $Command) {
            Write-Verbose -Message "Processing command $C1"
            $Params = Get-Parameters $C1 | Sort ParameterSet
            $ShowSets = ($Params | Select -Unique ParameterSet).Count -gt 1
            $PrevParamSet = ''
            $Response += "<form action='' method='post'>","<h1>$C1</h1>","<hr>"
            $Response += "<input type='hidden' name='InvokeCommand' value='1'>"
            
            foreach ($P1 in $Params) {

                $Name, $Type, $ParamSet = $P1.Name, $P1.Type, $P1.ParameterSet
                # TODO: If validate set, then drop-down
                # TODO: If Mandatory then bold or something

                if ($ShowSets -and ($ParamSet -ne $PrevParamSet)) {
                    $Response += "<h2>$ParamSet</h2>"
                    $PrevParamSet = $ParamSet
                }

                if (!$Bootstrap) {

                    # Standard HTML

                    $Line = "<p>$Name`: "
                    if ($Type -eq 'SwitchParameter') {
                        $Line = "$Line<input type='checkbox' name='$Name' value='1'>"  
                    } else {
                        $Line = "$Line<input type='text' name='$Name'>"
                    }
                    $Line = "$Line <i>($Type)</i></p>"
                    $Response += $Line
                } else {

                    # Bootstrap template 
                    
                    if ($Type -eq 'SwitchParameter') {
                        $Response += "<label class='checkbox-inline'><input type='checkbox' name=$Name value=1>$Name</label>"
                    } else {
                        $Response += "<div class='input-group'>","<span class='input-group-addon'>$Name</span>"
                        $Response += "<input type='text' class='form-control' name='$Name' placeholder='$Type'>","</div>"
                    }
                }
                # TODO: IF PSCredential, then build credential?
            }
            # Add submit button
            if (!$Bootstrap) {
                $Response += "<input type='submit' value='Submit!'>","</form>"
            } else {
                $Response += "<p></p><input type=submit value='Submit!' class='form-control'></div>"
            }
            
        }
    }

    END {
        # TODO: Add HTML finishing
        $Response += '</body>','</html>'

        if ($Invoke) {
            $TempFile = [System.IO.Path]::GetTempFileName() + '.html'
            $Response | Out-File $TempFile
            Invoke-Item $TempFile
        } elseif ($Clipboard) {
            $Response | Set-Clipboard
        } else {
            $Response
        }
    }
}

Set-Alias -Name cvpth -Value Convert-ParametersToHTML