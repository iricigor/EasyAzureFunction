#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

#
# Import module
#

$ModuleName = 'EasyAzureFunction'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (get-item $here).Parent.FullName
Import-Module (Join-Path $root "$ModuleName.psd1") -Force

#
# Fake test
#

Describe "Fake-Test" {
    It "Should be fixed by developer" {
        $true | Should -Be $true
    }
}


#
# Module should import two functions
#


Describe 'Proper Declarations' {
    
    It 'Checks for existence of functions' {
        @(Get-Command -Module $ModuleName -CommandType Function).Count | Should -Be 2 -Because 'We should have two functions defined'
        Get-Command Get-Parameter -ea 0 | Should -Not -Be $Null
        Get-Command New-AzureFunctionCode -ea 0 | Should -Not -Be $Null
        Get-Command NonExistingCommand -ea 0 | Should -Be $Null
    }

   It 'Checks for Aliases' {
       @(Get-Command -Module $ModuleName -CommandType Alias).Count | Should -Be 1 -Because 'We should have one alias defined'
       Get-Alias New-AzFC -ea 0 | Should -Not -Be $null
       Get-Alias NenExistingAlias -ea 0 | Should -Be $null
   }
}


#
# Check if documentation is proper
#

<#
Describe 'Proper documentation' {

	It 'Updates documentation and does git diff' {
		# install PlatyPS
		# Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
		Install-Module platyPS -Force
		Import-Module platyPS
		# update documentation 
		cd $here
		Update-MarkdownHelp -Path .\docs
		cd ..
		$diff = git diff
		$diff | Should -Be $null
	}
}
#>
