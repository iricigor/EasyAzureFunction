
[![Build status](https://ci.appveyor.com/api/projects/status/kkjs02jl860sx7ra?svg=true)](https://ci.appveyor.com/project/iricigor/easyazurefunction)

# EasyAzureFunction

This PowerShell module helps you to create local files for easy start with Azure Functions.
See **How to Use** section below for a quick start.

Note: ***Work is still in progress. Not all examples work as described!***

## Azure functions

Azure Functions is a solution for easily running small pieces of code, or "functions," in the cloud.
See Microsoft introduction [here](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)
and PowerShell specific introduction by Steve Lee [here](https://blogs.msdn.microsoft.com/powershell/2017/02/24/using-powershell-modules-in-azure-functions/)

## How to install

You can install this module from PowerShell Gallery (preferred way) or by cloning GitHub repository.

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
Import-Module .\EasyAzureFunction.psd1 -Force
```

## How to use

In order to fully use this module, you need have Azure function and do two simple steps

### Create Azure function

You would need to have default HTTP triggered PowerShell function created in your Azure subscription.
If you dont have Azure subscription, you can get free account [here](https://azure.microsoft.com/en-us/free/).

Creating AzF is fairly simple: Click on 'Create a resource', search and select 'Function App', fill in required values and click on 'Create'.
Once your App is deployed, find it under 'Function Apps' service group.
New function can be created by clicking on '+' next to 'Functions' drop down in the middle of the screen.

In order to use it with PowerShell, select 'Custom function' and then select 'Experimental Languages Support'
Now you can easily create 'HTTP trigger' / PowerShell function in couple of clicks. 
For this example, set Authorization level to 'Anonymous'.

### 1. Run command and generate files locally

```PowerShell
 New-AzureFunctionCode -Command Get-Process -Path C:\GP
```

You can select any PowerShell command instead of Get-Process.
You will get two files in folder: run.ps1 and index.html.

### 2. Copy generated files to your Azure function

In AzF you created, replace content of default 'run.ps1' with the one you created.
Under files section (far right), click on Add and create new file named 'index.html' and replace its content also.

Advanced users can do these actions also via FTP.

## Examples

See some basic examples for built in commands:

- [Get-Command](https://ezazf.azurewebsites.net/api/GC)
- [Get-Process](https://ezazf.azurewebsites.net/api/GP)
- [Get-Module](https://ezazf.azurewebsites.net/api/GM)

All of these links will open Azure Functions web page, so just click it and see it in action.

## Known limitations

- Generated html file only supports strings in input fields. If a command expects certain complex object (i.e. PSCredentials, PSSession, etc.), it will fail

## ToDo list

### Before publishing to 0.9

- [x] Add Pester tests
- [x] Add documentation, via PlatyPS
- [x] Add primary function to call two private ones
- [x] Add psd1
- [ ] Add CI/CD pipeline, publish to PSGallery
- [x] Add build badge
- [ ] Add go back link at the end of results page

### Do it later

- [ ] Add support for script with parameters and script with function(s) inside
- [ ] Add more tasks here, or in the issues (with link from here)
- [ ] Test with PowerShell core
- [ ] Unify argument names (Name vs CommandName vs Command), add support for pipeline from Get-Command
- [ ] Verify if command exists on remote system before running it, add switch PreCode?
- [ ] Add images for creating AzF, my examples
- [ ] Split readme into more MD files (like todo.md, etc.)

## Thanks list

- Tobias [@TobiasPSP](https://twitter.com/TobiasPSP) for great and inspiring PowerShell conference [PSConfEU](http://www.psconf.eu/) 2018
- Sergei [@xvorsx](https://twitter.com/xvorsx) for nice introduction to [PlatyPS](https://github.com/PowerShell/platyPS)
- Jakub [@nohwnd](https://github.com/nohwnd) for great testing framework [Pester](https://github.com/pester/Pester)
- Aleksandar [@alexandair](https://twitter.com/alexandair) - for great social component at the PSConfEU conference
- [The PowerShell team](https://twitter.com/PowerShell_Team) *(Joey, Steve and others)* - for great product!
