function New-AzureFunctionCode {

    # function creates two files: run.ps1 and index.html for specified command
    # files can be just uploaded to azure function and executed to simulate server-less command running 

    param (
        [string[]]$Command,
        [string]$Path = $env:TEMP, # TODO: This might not be compatible with PSCore
        [switch]$Invoke

    )

    # TODO: Add support for extra parameters, like bootstrap

    BEGIN {

    }

    PROCESS {
        foreach ($C1 in $Command) {
            
            # prepare folder
            if ($Command.Count -gt 1) {$P1 = Join-Path $Path $C1} 
            else {$P1 = $Path}
            if (!(Test-Path $P1)) {New-Item $P1 -ItemType Directory -Force | Out-Null}

            # check for existence of command
            if (!(Get-Command $C1)) {
                Write-Error "Cannot find command $C1"
                continue
            } else {
                $C1 = (Get-Command $C1).Name # setup proper capitalization
            }

            # generate files
            Convert-ParametersToHTML -Command $C1 -Bootstrap | Out-File (Join-Path $P1 'index.html') -Force -Encoding utf8
            Convert-ParametersToRunner -Command $C1 | Out-File (Join-Path $P1 'run.ps1') -Force -Encoding utf8
        }
    }

    END {
        if ($Invoke) {
            Invoke-Item $Path
        }
    }
}

Set-Alias -Name New-AzFC -Value New-AzureFunctionCode