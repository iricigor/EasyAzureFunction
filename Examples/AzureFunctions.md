# Easy Azure Function

This document describes how to start with Microsoft Azure Functions and PowerShell module EasyAzureFunction.

## Azure functions

Azure Functions is a solution for easily running small pieces of code, or "functions" in the cloud.
See Microsoft introduction [here](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)
and PowerShell specific introduction by Steve Lee [here](https://blogs.msdn.microsoft.com/powershell/2017/02/24/using-powershell-modules-in-azure-functions/).

## Create Azure Function for module EasyAzureFunction

You would need to have HTTP triggered PowerShell function created in your Azure subscription.
If you do not have Azure subscription, you can get free account [here](https://azure.microsoft.com/en-us/free/).

Creating AzF is fairly simple: Click on 'Create a resource', search and select 'Function App', fill in required values and click on 'Create'.
Once your App is deployed, find it under 'Function Apps' service group.
New function can be created by clicking on '+' next to 'Functions' drop down in the middle of the screen.

In order to use it with PowerShell, select 'Custom function' and then select 'Experimental Languages Support'
Now you can easily create 'HTTP trigger' / PowerShell function in couple of clicks.
For this example, set Authorization level to 'Anonymous'.

## Creating Azure Function Screenshot

![Creating Azure Function Screenshot](../Images/Create_ezAzF.png)