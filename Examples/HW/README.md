# Hello World example

This example generated with following command:

```PowerShell
$PC = 'function Hello([string]$Name="World"){"Hello $Name"}'
Invoke-Expression $PC
New-AzureFunctionCode  -CommandName Hello -PreCode $PC
```

Parameter -PreCode defines custom function **Hello** which will be executed (defined) within Azure Function.
This function should be also available in current user space in order for local functions to analyze it properly.