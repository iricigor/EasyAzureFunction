function New-AzureFunctionCode {

    # function creates two files: run.ps1 and index.html for specified command
    # files can be just uploaded to azure function and executed to simulate server-less command running 

    param (
        
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [Alias('Name')][string[]]$CommandName,

        [string]$Path = [system.io.path]::GetTempPath(),

        [string]$PreCode,

        [switch]$Invoke

    )

    # TODO: Add support for extra parameters, like bootstrap

    BEGIN {

    }

    PROCESS {
        foreach ($C1 in $CommandName) {
            
            # prepare folder
            if ($CommandName.Count -gt 1) {$P1 = Join-Path $Path $C1} 
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
            Convert-ParametersToRunner -Command $C1 -PreCode $PreCode | Out-File (Join-Path $P1 'run.ps1') -Force -Encoding utf8
        }
    }

    END {
        if ($Invoke) {
            try {Invoke-Item $Path} # TODO: Investigate why Invoke-Item /tmp fails under Linux, or just ignore switch under Linux?
            catch {Write-Error "Invoke failed. Output files are stored under $Path folder"}
        }
    }
}

Set-Alias -Name New-AzFC -Value New-AzureFunctionCode