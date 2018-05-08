function Convert-ParametersToHTML () {
    
    # Used to generate index.html file which is presented if Azure Function is called without default parameter

    # Example: Get-Parameters Get-Location | Convert-ParametersToHTML -Boot -Invoke
    
    param (
        
        [string]$Command,
        [switch]$Invoke,
        [switch]$Bootstrap,
        [switch]$Clipboard

    )

    BEGIN {
        $Prefix = 'Ez'
        $Response = @()
        $Response += '<!DOCTYPE html>','<html lang="en">','<head>'
        if ($Bootstrap) {
            $Response += '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">'
            $Response += '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>'
            $Response += '<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>'
        }
        $Response += '<title>EasyAzureFunction - ' + $Command + '- input parameters</title>'
        $Response += '</head>','','<body>'
        if ($Bootstrap) {$Response += '<div class="container">'}
    }

    PROCESS {
        foreach ($C1 in $Command) {  # initially, $Command was an array
            Write-Verbose -Message "Processing command $C1"
            $Params = Get-Parameter $C1 | Sort-Object ParameterSet
            $ShowSets = ($Params | Select -Unique ParameterSet).Count -gt 1
            $PrevParamSet = ''
            $Response += "<form method='post'>","<h1>$C1</h1>","<hr>"
            $Response += "<input type='hidden' name='$Prefix`InvokeCommand' value='1'>"
            
            foreach ($P1 in $Params) {

                $Name, $Type, $ParamSet = $P1.Name, $P1.Type, $P1.ParameterSet
                $M = if ($P1.Mandatory) {'* '} else {''}
                # TODO: If validate set, then drop-down
                # TODO: If Mandatory then bold or something

                if ($ShowSets -and ($ParamSet -ne $PrevParamSet)) {
                    $Response += "<h2>$ParamSet</h2>"
                    $PrevParamSet = $ParamSet
                }

                if (!$Bootstrap) {

                    # Standard HTML

                    $Line = "<p>$M$Name`: "
                    if ($Type -eq 'SwitchParameter') {
                        $Line = "$Line<input type='checkbox' name='$Prefix$Name' value='1'>"  
                    } else {
                        $Line = "$Line<input type='text' name='$Prefix$Name'>"
                    }
                    $Line = "$Line <i>($Type)</i></p>"
                    $Response += $Line
                } else {

                    # Bootstrap template 
                    
                    if ($Type -eq 'SwitchParameter') {
                        $Response += "<div class='form-check py-2'>"
                        $Response += "  <input type='checkbox' name=$Prefix$Name value=1>"
                        $Response += "  <label class='form-check-label'>$M$Name</label>"
                        $Response += "</div>"
                    } else {
                        $Response += "<div class='input-group py-2'>"
                        $Response += "  <span class='input-group-addon'>$M$Name</span>"
                        $Response += "  <input type='text' class='form-control' name='$Prefix$Name' placeholder='$Type'>"
                        $Response += "</div>"
                    }
                }
                # TODO: IF PSCredential, then build credential?
            }
            # Add submit button
            if (!$Bootstrap) {
                $Response += "<input type='submit' value='Submit!'>","</form>",'<p></p>'
                $Response += '<div>Created with <a href="https://github.com/iricigor/EasyAzureFunction">EasyAzureFunction module</a>'
                $Response += ' by <a href="mailto:iricigor@gmail.com?Subject=EasyAzureFunction">Igor Iric</a></div>'
            } else {
                $Response += "<p></p><input type=submit value='  Run $C1  ' class='btn btn-primary btn-block py-3'>","</form>",'<p></p>'
                $Response += '<div class="bg-info">Created with EasyAzureFunction module <a href="https://github.com/iricigor/EasyAzureFunction"><span class="glyphicon glyphicon-link"></span></a>'
                $Response += ' by Igor Iric <a href="mailto:iricigor@gmail.com?Subject=EasyAzureFunction"><span class="glyphicon glyphicon-envelope"></span></a></div>'
            }            
        }
    }

    END {
        $Response += '</div>','</body>','</html>'

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
