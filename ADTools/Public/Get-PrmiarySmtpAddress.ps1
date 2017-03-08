Function Get-PrmiarySmtpAddress
{
	<#
		.SYNOPSIS
		the primary SMTP address of an object.

		.DESCRIPTION
		the primary SMTP address of an object.

		.PARAMETER ProxyAddresses
		the proxyAddresses attribute to parse in order to determine
		primary SMTP address.

		.EXAMPLE
		> GetPrimarySmtpAddress -ProxyAddresses $ProxyAddresses

		.INPUTS
		.String[]

		.OUTPUTS
		.String

		.NOTES

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $True)]
		$ProxyAddresses
	)

	foreach ($proxyAddress In $ProxyAddresses) {
		If ([string]::Compare([string]$proxyAddress.substring(0,5),"SMTP:",$False) -eq 0)
		{
			$Result = $([string]$proxyAddress.substring(5))
		}
	}
	Return $Result
}

