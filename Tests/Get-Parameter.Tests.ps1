#
# Import module if needed, should be part of module testing
#

$ModuleName = 'EasyAzureFunction'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (get-item $here).Parent.FullName
if (!(Get-Module $ModuleName)) {
    Import-Module (Join-Path $root "$ModuleName.psd1") -Force
}

#
# Fake test
#

Describe "Fake-Test" {
    It "Should be fixed by developer" {
        $true | Should -Be $true
    }
}

#
# Check definition
#

$CommandName = 'Get-Parameter'
$ParameterNames = @('CommandName')

Describe "Function-GetParameter-Definition" {

    $CmdDef = Get-Command -Name $CommandName -Module $ModuleName -ea 0
    $CmdFake = Get-Command -Name 'FakeCommandName' -Module $ModuleName -ea 0

    It "Command should exist" {
        $CmdDef | Should -Not -Be $null
        $CmdFake | Should -Be $null
    }

    It 'Command should have parameters' {
        $CmdDef.Parameters.Keys | Should -Not -Contain 'FakeParameterName'
        foreach ($P1 in $ParameterNames) {
            $CmdDef.Parameters.Keys | Should -Contain $P1
        }
    }
}



#
# Check functionality, real tests
#

$ResultAttributes = @('Mandatory','Command','Name','Type','ParameterSet','ValidateSet')
Describe "Function-GetParameter-Functionality" {

    It 'Result should have required properties' {
        $Results = Get-Parameter Get-Parameter | Select -First 1
        foreach ($Attr in $ResultAttributes) {
            $Attr | Should -BeIn $Results.PSObject.Properties.Name
        }    
    }

    It 'Get-Command has validate set on CommandType' {
        $Results = Get-Parameter Get-Command | ? Name -eq CommandType
        $Results.ValidateSet | Should -Not -BeNullOrEmpty
    }

    It 'Reads also scripts' {
        $TestScript = Join-Path $here 'LoremIpsum.ps1'
        $TestScript | Should -Exist
        $Result = Get-Parameter -ScriptName $TestScript 
        $Result | Should -Not -BeNullOrEmpty
    }

    It 'Supports Switch IncludeCommonParams' {
        $Results1 = Get-Parameter Get-Parameter
        $Results2 = Get-Parameter Get-Parameter -IncludeCommonParameters
        $Results2.Count | Should -BeGreaterThan $Results1.Count
    }
}
