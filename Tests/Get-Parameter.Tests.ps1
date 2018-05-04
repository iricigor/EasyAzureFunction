#
# Import module if needed, should be part of module testing
#

$ModuleName = 'EasyAzureFunction'
if (!(Get-Module $ModuleName)) {
    $here = Split-Path -Parent $MyInvocation.MyCommand.Path
    $root = (get-item $here).Parent.FullName
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

Describe "Function-Definition" {

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

$ResultAttributes = @('Mandatory','Command','Name','Type','ParameterSet')
Describe "Function-Functionality" {

    It 'Result should have required properties' {
        $Results = Get-Parameter Get-Parameter
        foreach ($Attr in $ResultAttributes) {
            $Results.$Attr | Should -Not -BeNullOrEmpty
        }    
    }
}
