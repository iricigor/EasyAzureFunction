function Get-Parameter () {

    param (        

        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [Alias('Name')][string[]]$CommandName

    )
    # TODO: Add Verbose output
    
    BEGIN {
        # function begin phase
        $CommandName = $MyInvocation.MyCommand.Name
        Write-Verbose -Message "$(Get-Date -f G) $CommandName starting"

        $CommonParams = 'Verbose,Debug,ErrorAction,WarningAction,InformationAction,ErrorVariable,WarningVariable,InformationVariable,OutVariable,OutBuffer,PipelineVariable' -split ','
    }

    PROCESS {

        foreach ($C1 in $CommandName) {
            if ($CommandName.Count -gt 1) {Write-Verbose -Message "$(Get-Date -f T)   Processing $C1"}

            # Obtain list of parameters from script or command
            if ($C1 -match '\.ps1') {
                throw "Script support not yet implemented. Expected in version 0.6"
            } else {
                try {
                    $Params = Get-Command -Name $C1 | Select -expand Parameters
                } catch {
                    Write-Error "Command $C1 not found."
                    continue
                }
            }
            
            # process parameters
            if (!($Params.Keys)) {Write-Verbose -Message "$(Get-Date -f T)   found no parameters on $C1" }
            else {Write-Verbose -Message "$(Get-Date -f T)   Parsing list of parameters: $($Params.Keys -join ',')"}
              
            foreach ($P1 in $Params.Keys) {
                if ($P1 -in $CommonParams) {continue} # TODO: Add switch to include CommonParams
                $PObj = $Params.$P1

                $Type = $PObj.ParameterType 
                if ($Type.BaseType -eq [System.Enum]) {$Values = [System.Enum]::GetNames($Type)} else {$Values = $null}

                foreach ($ParamSetName in $PObj.ParameterSets.Keys) {
                    New-Object PSObject -Property @{
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
        Write-Verbose -Message "$(Get-Date -f T) $CommandName finished"

    }
}