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

$CommandName = 'New-AzureFunctionCode'
$ParameterNames = @('CommandName','Path','Invoke')

Describe "Function-Definition" {

    $CmdDef = Get-Command -Name $CommandName -Module $ModuleName -ea 0
    $CmdFake = Get-Command -Name 'FakeCommandName' -Module $ModuleName -ea 0

    It "Command should exist" {
        $CmdDef | Should -Not -Be $null
        $CmdFake | Should -Be $null
    }

    It 'Alias should exist' {
        Get-Alias -Definition $CommandName -ea 0 | Should -Not -Be $null
        Get-Alias -Definition 'FakeCommandName' -ea 0 | Should -Be $null
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

Describe "Function-Functionality" {

    $Folder0 = [system.io.path]::GetTempPath()
    $Commands = @('Get-Command','Get-Process')

    It 'Files should not be there before running command' {
        $File1 =Join-Path $Folder0 'index.html'
        $File2 =Join-Path $Folder0 'run.ps1'
        if (Test-Path $File1) {Remove-Item $File1 -Force}
        if (Test-Path $File2) {Remove-Item $File2 -Force}
        $File1 | Should -Not -Exist
        $File2 | Should -Not -Exist
    }
    It 'Should generate two files in a folder' {
        # run command
        New-AzureFunctionCode -Command $Commands[0]
        # check results
        Join-Path $Folder0 'index.html' | Should -Exist
        Join-Path $Folder0 'run.ps1' | Should -Exist
        Join-Path $Folder0 'FakeFileName' | Should -Not -Exist
    }

    It 'Command subfolders should not exist before running command' {
        foreach ($C1 in $Commands) {
            $Folder1 = Join-Path  $Folder0 $C1 
            if (Test-Path $Folder1) {Remove-Item $Folder1 -Force -Recurse}
            $Folder1 | Should -Not -Exist
        }
    }

    It 'Should create subfolders for multiple commands' {
        New-AzureFunctionCode -Command $Commands
        foreach ($C1 in $Commands) {
            $Folder = Join-Path $Folder0 $C1
            Join-Path $Folder 'index.html' | Should -Exist
            Join-Path $Folder 'run.ps1' | Should -Exist
            Join-Path $Folder 'FakeFileName' | Should -Not -Exist
        }
    }

    It 'All *.ps1 files should have valid syntax' {
        $TestFunction = Join-Path $here 'Test-PowerShellSyntax.ps1'
        $TestFunction | Should -Exist
        . $TestFunction
        foreach ($C1 in $Commands) {
            $Folder = Join-Path $Folder0 $C1
            (Test-PowerShellSyntax -Path (Join-Path $Folder 'run.ps1')).SyntaxErrorsFound | Should -Be $false
        }
    }

    It 'All *.html files should have valid syntax' {
        $TestFunction = Join-Path $here 'Test-HTMLSyntax.ps1'
        $TestFunction | Should -Exist
        . $TestFunction
        foreach ($C1 in $Commands) {
            $Folder = Join-Path $Folder0 $C1
            Test-HTMLSyntax -Path (Join-Path $Folder 'index.html') | ? type -eq 'error' | Should -Be $null
        }
    }

    It 'Generates three files for processed script' {
        $TestScript = Join-Path $here 'LoremIpsum.ps1'
        $TestScript | Should -Exist

        $Folder1 = Join-Path $Folder0 'LoremIpsum'
        if (Test-Path $Folder1) {Remove-Item $Folder1 -Force -Recurse}
        $Folder1 | Should -Not -Exist
        
        New-AzFC -ScriptName $TestScript -Path $Folder1
        $NewFiles = Get-ChildItem $Folder1 
        $NewFiles.Count | Should -Be 3
    }

}
