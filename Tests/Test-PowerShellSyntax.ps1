# https://powershell.org/forums/topic/how-to-check-syntax-of-scripts-automatically/
function Test-PowerShellSyntax
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Path
    )

    process
    {
        foreach ($scriptPath in $Path) {
            $contents = Get-Content -Path $scriptPath

            if ($null -eq $contents)
            {
                continue
            }

            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)

            New-Object psobject -Property @{
                Path = $scriptPath
                SyntaxErrorsFound = ($errors.Count -gt 0)
            }
        }
    }
}
