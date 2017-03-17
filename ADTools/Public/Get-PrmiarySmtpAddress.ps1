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

	param
	(
		[Parameter(Mandatory = $True,
                   ParameterSetName = 'ProxyAddresses')]
        [Microsoft.ActiveDirectory.Management.ADPropertyValueCollection]
		$ProxyAddresses,
        
		[Parameter(Mandatory = $True,
                   ParameterSetName = 'ADUser')]
        [Microsoft.ActiveDirectory.Management.ADUser]
		$ADUser
	)

    if ($PSCmdlet.ParameterSetName -eq 'ADUser')
    {
        if ($ADUser.proxyAddresses -is [Microsoft.ActiveDirectory.Management.ADPropertyValueCollection] -and `
            $ADUser.proxyAddresses.Count -gt 0)
        {
            $ProxyAddresses = $ADUser.proxyAddresses
        }
        else
        {
            [System.Exception.ArgumentException]::new('Invalid or no proxyAddresses on user.')
        }
    }

    GetPrimarySmtpAddressFromProxyAddresses -ProxyAddresses $ProxyAddresses
}

