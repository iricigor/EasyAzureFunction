# EasyAzureFunction

[![Build status](https://ci.appveyor.com/api/projects/status/kkjs02jl860sx7ra?svg=true)](https://ci.appveyor.com/project/iricigor/easyazurefunction)
[![Skype icon](Images/skype-icon.png)](skype:iricigor?chat)

This PowerShell module helps you to create local files for easy start with Azure Functions.
See **How to Use** section below for a quick start.

If you already have your Azure Function created (or you know how to do it), then just run ```New-AzFC <MyCommand>``` and upload generated files to your function! Simple as that!

If you want to learn how PowerShell Azure Function works, check run.ps1 files under [Examples](Examples) folders.

## Azure functions

Azure Functions is a solution for easily running small pieces of code, or "functions" in the cloud.
See Microsoft introduction [here](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)
and PowerShell specific introduction by Steve Lee [here](https://blogs.msdn.microsoft.com/powershell/2017/02/24/using-powershell-modules-in-azure-functions/).

## How to install

You can install this module from PowerShell Gallery (preferred way) or by cloning GitHub repository.

### From PSGallery

```PowerShell
Find-Module EasyAzureFunction -Repository PSGallery | Install-Module -Scope CurrentUser -Force
```

### From GitHub

```PowerShell
git clone https://github.com/iricigor/EasyAzureFunction.git      # Clone this repository
Import-Module .\EasyAzureFunction\EasyAzureFunction.psd1 -Force  # Import module
```

## How to use

In order to fully use this module, you need have Azure function and do two simple steps.

### Create Azure Function

You would need to have HTTP triggered PowerShell function created in your Azure subscription.
If you do not have Azure subscription, you can get free account [here](https://azure.microsoft.com/en-us/free/).

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

Here are some basic examples for built in PowerShell commands. All of these links will open Azure Functions web page, so just click it and see it in action.

- [Get-Command](https://ezazf.azurewebsites.net/api/GC) - type Pester as value for parameter -Module
- [Get-Process](https://ezazf.azurewebsites.net/api/GP) - run without any parameters to see all visible processes
- [Get-Module](https://ezazf.azurewebsites.net/api/GM) - run with -ListAvailable

And here are some examples using non-Get functions

- [Write-Output](https://ezazf.azurewebsites.net/api/WO) - try to create 'Hello world!' example
- [Hello-World](https://ezazf.azurewebsites.net/api/HW) - created with -PreCode parameter, see [Examples/HW](Examples/HW) folder

## Known limitations

- Generated html file only supports strings in input fields. If a command expects certain complex object (i.e. PSCredentials, PSSession, etc.), it will fail

## Thanks list

- Tobias [@TobiasPSP](https://twitter.com/TobiasPSP) for great and inspiring conference [PSConfEU](http://www.psconf.eu/) 2018
- Sergei [@xvorsx](https://twitter.com/xvorsx) for nice introduction to [PlatyPS](https://github.com/PowerShell/platyPS)
- Jakub [@nohwnd](https://github.com/nohwnd) for great testing framework [Pester](https://github.com/pester/Pester)
- Aleksandar [@alexandair](https://twitter.com/alexandair) - for great social component at the PSConfEU conference
- [The PowerShell team](https://twitter.com/PowerShell_Team) *(Joey, Steve and others)* - for great product!
