function Get-Parameter () {

    param (        

        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [Alias('Name')][string[]]$CommandName

    )
    # TODO: Add Verbose output
    
    BEGIN {
        $CommonParams = 'Verbose,Debug,ErrorAction,WarningAction,InformationAction,ErrorVariable,WarningVariable,InformationVariable,OutVariable,OutBuffer,PipelineVariable' -split ','
    }

    PROCESS {

        foreach ($C1 in $CommandName) {
            $Params = Get-Command -Name $C1 | Select -expand Parameters
            
            foreach ($P1 in $Params.Keys) {
                if ($P1 -in $CommonParams) {continue} # TODO: Add switch to include CommonParams
                $PObj = $Params.$P1

                $Type = $PObj.ParameterType 
                if ($Type.BaseType -eq [System.Enum]) {$Values = [System.Enum]::GetNames($Type)} else {$Values = @()}
                # TODO: Add list of possible values (i.e. ValidateSet), not tested and not used code above

                foreach ($ParamSetName in $PObj.ParameterSets.Keys) {
                    New-Object PSObject -Property @{
                        Command = $C1
                        Name = $P1
                        Type = $PObj.ParameterType.Name
                        Mandatory = $PObj.Attributes | ? ParameterSetName -eq $ParamSetName | Select -expand Mandatory
                        ParameterSet = $ParamSetName
                    }                    
                }
            }        
        }
    }

    END {}
}