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
Get-Parameter [-CommandName] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Function lists parameters for a given command

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-Parameter Get-Location
```

It will return an array with all 5 parameters that commandlet Get-Location has.

## PARAMETERS

### -CommandName
Specify for which command it will output parameters.

Ultimately, this value(s) will be passed to **Get-Command** commandlet.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### EzAzF_ParameterInfo

## NOTES

## RELATED LINKS

[GitHub repository](https://github.com/iricigor/EasyAzureFunction)