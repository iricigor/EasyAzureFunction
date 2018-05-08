function Test-HTMLSyntax {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Path
    )

    begin {
        $uri = $uri = 'https://validator.w3.org/nu/?out=json'
        $H = @{'Content-type'='text/html; charset=utf-8'}
    }

    process {
        foreach ($scriptPath in $Path) {
            
            $contents = Get-Content -Path $scriptPath
            if ($null -eq $contents) {continue}

            $Result = Invoke-WebRequest -Uri $uri -Headers $H -Body $contents -Method Post
            ($Result.Content | ConvertFrom-Json).messages

        }
    }
}