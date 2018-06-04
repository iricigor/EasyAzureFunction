function Get-Parameter () {

    param (

        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [Alias('Name','ScriptName')][string[]]$CommandName,

        [switch]$IncludeCommonParameters

    )

    BEGIN {
        # function begin phase
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose -Message "$(Get-Date -f G) $FunctionName starting"

        $CommonParams = 'Verbose,Debug,ErrorAction,WarningAction,InformationAction,ErrorVariable,WarningVariable,InformationVariable,OutVariable,OutBuffer,PipelineVariable,WhatIf,Confirm' -split ','
    }

    PROCESS {

        foreach ($C1 in $CommandName) {
            if ($CommandName.Count -gt 1) {Write-Verbose -Message "$(Get-Date -f T)   Processing $C1"}

            # Obtain list of parameters from script or command
            Write-Verbose -Message "$(Get-Date -f T)   Checking $C1"
            try {
                $Params = Get-Command -Name $C1 -ea stop | Select -expand Parameters
            } catch {
                Write-Error "Could not read parameters from $C1"
                continue
            }

            # process parameters
            if (!($Params.Keys)) {Write-Verbose -Message "$(Get-Date -f T)   found no parameters on $C1" }
            else {Write-Verbose -Message "$(Get-Date -f T)   Parsing list of parameters: $($Params.Keys -join ',')"}

            foreach ($P1 in $Params.Keys) {
                if (($P1 -in $CommonParams) -and (!$IncludeCommonParameters)) {continue}
                $PObj = $Params.$P1

                $Type = $PObj.ParameterType
                if ($Type.BaseType -eq [System.Enum]) {$Values = [System.Enum]::GetNames($Type)} else {$Values = $null}

                foreach ($ParamSetName in $PObj.ParameterSets.Keys) {
                    New-Object EzAzF_ParameterInfo -Property @{
                        Command = $C1
                        Name = $P1
                        Type = $PObj.ParameterType.Name
                        Mandatory = $PObj.Attributes | ? ParameterSetName -eq $ParamSetName | Select -expand Mandatory
                        ParameterSet = $ParamSetName
                        ValidateSet = $Values
                    }
                }
            }
        }
    }

    END {
        # function closing phase
        Write-Verbose -Message "$(Get-Date -f T) $FunctionName finished"
    }
}