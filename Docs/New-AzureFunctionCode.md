---
external help file: EasyAzureFunction-help.xml
Module Name: EasyAzureFunction
online version:
schema: 2.0.0
---

# New-AzureFunctionCode

## SYNOPSIS
Function generates two files (index.html and run.ps1) that can be used to run Azure Function.

## SYNTAX

```
New-AzureFunctionCode [[-Command] <String[]>] [[-Path] <String>] [-Invoke]
```

## DESCRIPTION
Function generates two files (index.html and run.ps1) that can be used to run Azure Function. File run.ps1 is default runner script that is executed each time new request is received. In case, there are no parameters passed by, it will invoke default page index.html which helps to submit parameters.

For more info, see README on GitHub repository, link is provided below.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-AzureFunctionCode Get-Command -Invoke
```

It will generate files used for running PowerShell commandlet **Get-Command** in Azure Function.

Files will be located in user's TEMP folder which will be invoked (opened) via default application (usually Windows Explorer)

### Example 2
```powershell
PS C:\> New-AzureFunctionCode -Command Get-Location, Get-Process -Path C:\EzAzF
```

It will generate files used for running specified two PowerShell commandlets.

Each commandlet will get its own folder under specified path.

## PARAMETERS

### -Command
Name of the command for which files will be generated. 

Ultimately, this value(s) will be passed to **Get-Command** commandlet.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Invoke
If specify it will open target folder where new files are located.

If more than one command is specified, it will open parent folder.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path where new files will be located.
If folder is not existing, it will be created.
If files in the folder are existing, they will be overwritten.

If more than one command is specified, each command will get sub-folder under path. Name of sub-folder will be equal to command name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[GitHub repository](https://github.com/iricigor/EasyAzureFunction)