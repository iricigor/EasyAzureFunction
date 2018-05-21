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
New-AzureFunctionCode -CommandName <String[]> [[-Path] <String>] [-PreCode <String>] [-PostCode <String>]
 [-Invoke] [<CommonParameters>]
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

Files will be located in TEMP folder which will be invoked (opened) via default application (usually Windows Explorer)

### Example 2

```powershell
PS C:\> New-AzureFunctionCode -Command Get-Location, Get-Process -Path C:\EzAzF
```

It will generate files used for running specified two PowerShell commandlets.

Each commandlet will get its own folder under specified path.

### Example 3

```powershell
PS C:\> New-AzureFunctionCode  -CommandName Hello -PreCode 'function Hello([string]$Name="World"){"Hello $Name"}'
```

Example shows how to use **-PreCode** to execute custom code before running actual command within Azure Function.

Parameter -PreCode can be also used to install/import third party modules from the Internet.

### Example 4

```powershell
PS C:\> New-AzureFunctionCode  -ScriptName LoremIpsum.ps1
```

You can generate a Azure Function also for your custom scripts that have input parameters.
Do not forget to copy to Azure also that custom script. Runner script will execute it in cloud with selected parameters.

Parameter -PreCode can be also used to install/import third party modules from the Internet.

## PARAMETERS

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

### -CommandName

Name of the command for which files will be generated.
Ultimately, this value(s) will be passed to Get-Command commandlet.

It can be also specified as script name (ending with .ps1), if that script has input parameters. 
Commandlet will also copy mentioned script to target folder, next to standard two files index.html and run.ps1.
You need to copy your custom script (i.e. all three files from folder) to Azure Function folder before running it in cloud.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name, ScriptName

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -PreCode
If you want to execute custom PowerShell commands before running your command, specify it as -PreCode.
This can be for example definition of your custom function, or installing/importing some 3rd party modules.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PostCode
If you want to execute custom PowerShell commands after running your command, specify it as -PostCode.
This is similar to -PreCode attribute.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[GitHub repository](https://github.com/iricigor/EasyAzureFunction)