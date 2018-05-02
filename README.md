# EasyAzureFunction

This PowerShell module helps you to create local files for easy start with Azure Functions.

Note: ***Work is still in progress. Not all examples work as described!***

## Azure functions

## How to install

### From PSGallery

```PowerShell
Find-Module EasyAzureFunction | Install-Module -Scope CurrentUser -Force
```

### From GitHub

``` PowerShell
# Create empty folder and go into it
New-Item -Name EasyAzureFunction -ItemType Directory
Set-Location  .\EasyAzureFunction
# Clone this repository
git clone https://github.com/iricigor/EasyAzureFunction.git
# Import module
Import-Module .\EasyAzureFunction.psm1 -Force
```

## How to use

## Examples

See some basic examples for built in commands:

- [Get-Command](https://ezazf.azurewebsites.net/api/GC)
- [Get-Process](https://ezazf.azurewebsites.net/api/GP)

All of these links will open Azure Functions web page, so just click it and see it in action.

## ToDo list

- [ ] Add Pester tests
- [ ] Add documentation, via PlatyPS
- [ ] Add primary function to call two private ones
- [ ] Add psd1
- [ ] Add CI/CD pipeline, publish to PSGallery
- [ ] Add support for script with parameters and script with function(s) inside
- [ ] Add more tasks here, or in the issues (with link from here)
- [ ] Test with PowerShell core
- [ ] Unify argument names (Name vs CommandName vs Command), add support for pipeline from Get-Command


## Thanks list

- Tobias [@TobiasPSP](https://twitter.com/TobiasPSP) for great and inspiring PowerShell conference [PSConfEU](http://www.psconf.eu/) 2018
- Sergei [@xvorsx](https://twitter.com/xvorsx) for nice introduction to [PlatyPS](https://github.com/PowerShell/platyPS)
- Jakub [@nohwnd](https://github.com/nohwnd) for great PowerShell testing framework [Pester](https://github.com/pester/Pester)
- Aleksandar [@alexandair](https://twitter.com/alexandair) - for great social component at the PSConfEU conference
- [The PowerShell team](https://twitter.com/PowerShell_Team) *(Joey, Steve and others)* - for great product!
