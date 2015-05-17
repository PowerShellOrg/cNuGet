function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$ProviderName
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."

  $Prov = Get-PSRepository -Name $ProviderName -ErrorAction SilentlyContinue
	@{
		ProviderName = $Prov.Name
		PublishURI = $Prov.PublishLocation
		SourceURI = $Prov.SourceLocation
		InstallPolicy = $prov.InstallationPolicy
	}
	#>
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory)]
		[System.String]
		$ProviderName,

		[parameter(Mandatory)]
    [System.String]
		$PublishURI,
    
    [parameter(Mandatory)]
		[System.String]
		$SourceURI,

		[System.String]
		$InstallPolicy = 'Trusted'
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."
  Write-Verbose "Checking for provider: $ProviderName"
  if (! (provider -Name $ProviderName -Action test ))
    {
      Write-Verbose 'creating new provider'
      provider -Name $ProviderName -Action set -PublisherURI $PublishURI -SourceURI $SourceURI -Type $InstallPolicy
    }

	#Include this line if the resource requires a system reboot.
	#$global:DSCMachineStatus = 1


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory)]
		[System.String]
		$ProviderName,

		[parameter(Mandatory)]
    [System.String]
		$PublishURI,
    
    [parameter(Mandatory)]
		[System.String]
		$SourceURI,

		[System.String]
		$InstallPolicy
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."
  Write-Verbose "Checking for provider: $ProviderName"
  provider -Name $ProviderName -Action test

	<#
	$result = [System.Boolean]
	
	$result
	#>
}


Export-ModuleMember -Function *-TargetResource

