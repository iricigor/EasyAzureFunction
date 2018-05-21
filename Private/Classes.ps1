Class EzAzF_ParameterInfo {
	[ValidateNotNullOrEmpty()][string]$Command
	[ValidateNotNullOrEmpty()][string]$Name
    [ValidateNotNullOrEmpty()][string]$Type
    [ValidateNotNullOrEmpty()][string]$ParameterSet
	[bool]$Mandatory
	[string[]]$ValidateSet
}