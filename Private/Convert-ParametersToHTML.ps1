function Convert-ParametersToHTML () {

    # Used to generate index.html file which is presented if Azure Function is called without default parameter

    # Example: Get-Parameters Get-Location | Convert-ParametersToHTML -Boot -Invoke

    param (

        [string]$Command,            # command(s) which will be analyzed
        [switch]$Invoke,             # should we invoke (open) output folder, works only on Windows
        [switch]$Bootstrap,          # should we use standardHTML or bootstrapped
        [switch]$Clipboard,          # if selected, output is copied to clipboard, !! compatible only with v.5.1
        [string]$MandatoryMark = '*' # how to additionally label mandatory parameter

    )

    BEGIN {
        $Prefix = 'Ez'
        $Response = @()
        $Response += '<!DOCTYPE html>','<html lang="en">','<head>','<meta charset="utf-8"/>'
        if ($Bootstrap) {
            $Response += '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">'
            $Response += '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>'
            $Response += '<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>'
        }
        $Response += '<title>EasyAzureFunction - ' + $Command + ' - input parameters</title>'
        $Response += '</head>','','<body>'
        if ($Bootstrap) {$Response += '<div class="container">'}
    }

    PROCESS {
        foreach ($C1 in $Command) {  # initially, $Command was an array
            Write-Verbose -Message "Processing command $C1"
            $Params = Get-Parameter $C1 | Sort-Object ParameterSet,Mandatory,Name
            $ShowSets = ($Params | Select -Unique ParameterSet).Count -gt 1
            $PrevParamSet = ''
            $Response += "<form method='post'>","<h1>$C1</h1>","<hr>"
            $Response += "<input type='hidden' name='$Prefix`InvokeCommand' value='1'>"

            foreach ($P1 in $Params) {

                $Name, $Type, $ParamSet, $ValidateSet = $P1.Name, $P1.Type, $P1.ParameterSet, $P1.ValidateSet
                $M = if ($P1.Mandatory) {$MandatoryMark} else {''}

                if ($ShowSets -and ($ParamSet -ne $PrevParamSet)) {
                    $Response += "<h2>$ParamSet</h2>"
                    $PrevParamSet = $ParamSet
                }

                if (!$Bootstrap) {

                    # Standard HTML

                    $Line = "<p>$M$Name`: "
                    if ($Type -eq 'SwitchParameter') {
                        $Line = "$Line<input type='checkbox' name='$Prefix$Name' value='1'>"
                    } elseif ($ValidateSet) {
                        $Line += "<select name=$Prefix$Name><option value=`"`">Select:</option>"
                        $ValidateSet | % {$Line += "<option>$_</option>"}
                        $Line += '</select>'
                    } elseif ($Type -eq 'PSCredential') {
                        $Line += "<input type='text' name='$Prefix$Name`UserName'>"
                        $Line += "<input type='password' name='$Prefix$Name`Password'>"
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
                    } elseif ($Type -eq 'PSCredential') {
                        $Response += "<div class='input-group py-2'>"
                        # TODO: Currently it lists username and password in two rows, it can be also one; add selector switch for this behavior, issue #36
                        # $Response += "  <span class='input-group-addon'>$M$Name.UserName</span>"
                        $Response += "  <span class='input-group-addon'>$M$Name</span>"
                        $Response += "  <input type='text' class='form-control' name='$Prefix$Name`UserName' placeholder='Enter Username'>"
                        # $Response += "  <span class='input-group-addon'>$M$Name.Password</span>"
                        $Response += "  <input type='password' class='form-control' name='$Prefix$Name`Password' placeholder='Enter Password'>"
                        $Response += '</div>'
                    } elseif ($ValidateSet) {
                        $Response += "<div class='input-group py-2'>","  <span class='input-group-addon'>$M$Name</span>"
                        $Response += "  <select name=$Prefix$Name class='form-control'>", '    <option value="" style="color: #cccccc;">Select:</option>'
                        $Response += $ValidateSet | % {"    <option>$_</option>"}
                        $Response += '  </select>','</div>'
                    } else {
                        $Response += "<div class='input-group py-2'>"
                        $Response += "  <span class='input-group-addon'>$M$Name</span>"
                        $Response += "  <input type='text' class='form-control' name='$Prefix$Name' placeholder='$Type'>"
                        $Response += "</div>"
                    }
                }
            }
            # Add submit button
            if (!$Bootstrap) {
                $Response += "<input type='submit' value='  Run $C1  '>","</form>",'<p></p>'
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
