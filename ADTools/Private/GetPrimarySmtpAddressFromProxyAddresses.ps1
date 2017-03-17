<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function GetPrimarySmtpAddressFromProxyAddresses
{
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   Position=0)]
        $ProxyAddresses
    )

    foreach ($proxyAddress In $ProxyAddresses) {
	If ([string]::Compare([string]$proxyAddress.substring(0,5),"SMTP:",$False) -eq 0)
	{
		$Result = $([string]$proxyAddress.substring(5))
	}
	}
	Write-Output $Result
}