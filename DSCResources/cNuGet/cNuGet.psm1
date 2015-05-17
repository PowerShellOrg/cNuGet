Import-Module $PSScriptRoot\..\..\tools.psm1

function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$PackageSource,

		[System.String]
		$APIKey,

		[System.Boolean]
		$AllowNugetPackagePush,

		[parameter()]
		[System.Boolean]
		$AllowPackageOverwrite
	)
  $Conf = webconfvar -AllowNugetPackagePush $AllowNugetPackagePush -AllowPackageOverwrite $AllowPackageOverwrite -PackageSource $PackageSource -APIKey $APIKey
	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."

	$returnValue = @{
		IISInstalled = IIS -Action Test
		ASPInstalled = ASP -Action Test
		WWWRootFiles = Zip -action test
		WebConfig = webconf -Conf $Conf -Action test
	}

	$returnValue
	#>
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$PackageSource,

		[System.String]
		$APIKey,

		[System.Boolean]
		$AllowNugetPackagePush,

		[parameter()]
		[System.Boolean]
		$AllowPackageOverwrite
	)
  $Conf = webconfvar -AllowNugetPackagePush $AllowNugetPackagePush -AllowPackageOverwrite $AllowPackageOverwrite -PackageSource $PackageSource -APIKey $APIKey
	Write-Verbose 'Working on IIS install'
  if (! (IIS -Action test))
    {
      Write-Verbose 'Installing IIS'
      IIS -Action set
    }
  Write-Verbose 'Working on ASPNet'
  if (! (ASP -Action test))
    {
      Write-Verbose 'Installing ASPNet'
      ASP -Action set
    }
  Write-Verbose 'Working on package directory'
  if (! (pkg -Action test -path $PackageSource))
    {
      Write-Verbose 'Creating Package directory'
      pkg -Action set -path $PackageSource
    }
  Write-Verbose 'Checking WWWRoot files'
  if (! (Zip -Action test ))
    {
      Write-Verbose 'Building out wwwroot'
      Zip -Action set
    }
  Write-Verbose 'Checking Web.config'
  if (! (webconf -Action test -Conf $Conf))
    {
      Write-Verbose 'setting web.config'
      webconf -Action set -Conf $Conf
    }
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$PackageSource,

		[System.String]
		$APIKey,

		[System.Boolean]
		$AllowNugetPackagePush,

		[parameter()]
		[System.Boolean]
		$AllowPackageOverwrite
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."
  $Conf = webconfvar -AllowNugetPackagePush $AllowNugetPackagePush -AllowPackageOverwrite $AllowPackageOverwrite -PackageSource $PackageSource -APIKey $APIKey
	Write-Verbose 'Testing IIS install'
  if (! (IIS -Action test))
    {
      return $false
    }
  Write-Verbose 'Testing on ASPNet'
  if (! (ASP -Action test))
    {
      return $false
    }
  Write-Verbose 'Testing package directory'
  if (! (pkg -Action test -path $PackageSource))
    {
      return $false
    }
  Write-Verbose 'Checking WWWRoot files'
  if (! (Zip -Action test ))
    {
      return $false
    }
  Write-Verbose 'Checking Web.config'
  if (! (webconf -Action test -Conf $Conf))
    {
      return $false
    }
  return $true

	<#
	$result = [System.Boolean]
	
	$result
	#>
}


Export-ModuleMember -Function *-TargetResource

