---
external help file: EasyAzureFunction-help.xml
Module Name: EasyAzureFunction
online version:
schema: 2.0.0
---

# Get-Parameter

## SYNOPSIS
Function lists parameters for a given command

## SYNTAX

```
Get-Parameter [-CommandName] <String[]> [-IncludeCommonParameters] [<CommonParameters>]
```

## DESCRIPTION
Function lists parameters for a given command

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-Parameter Get-Location
```

It will return an array with all 5 parameters that commandlet Get-Location has.

### Example 2
```powershell
PS C:\> Get-Parameter Get-Command | Format-Table
```

For majority of commands, it is better to format output as table, if no further processing is done.

### Example 3
```powershell
PS C:\> Get-Command *-Host | Get-Parameter | Format-Table
```

Input for Get-Command can be also via pipeline.

### Example 4
```powershell
PS C:\> Get-Command -Module Microsoft.* | Get-Parameter | ? Mandatory | ? ValidateSet | Format-Table
```

Lists all mandatory parameters with predefined set of values in all loaded Microsoft modules.

### Example 5
```powershell
PS C:\> Get-Parameter -ScriptName LoremIpsum.ps1
```

Lists all parameters for a given script name.

## PARAMETERS

### -CommandName
Specify for which command it will output parameters.

Ultimately, this value(s) will be passed to **Get-Command** commandlet.

It can be also specified as script name (ending with .ps1), if that script has input parameters.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name, ScriptName

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -IncludeCommonParameters
By default, script will exclude common parameters (like -Verbose, -ErrorAction, etc.) even if they are supported by command. If you want them included, specify this switch.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### EzAzF_ParameterInfo

## NOTES

## RELATED LINKS

[GitHub repository](https://github.com/iricigor/EasyAzureFunction)