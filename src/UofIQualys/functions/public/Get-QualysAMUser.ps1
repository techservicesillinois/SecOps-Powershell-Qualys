<#
    .SYNOPSIS
        Returns the Administration User object of a Qualys User.
    .DESCRIPTION
        Returns the Administration User object of a Qualys User.
    .PARAMETER Login
        The User Login of the user to get the AM object for.
    .PARAMETER Credential
        The credential object to log into Qualys.
    .EXAMPLE
        Get-QualysAMUser -Login "theun_zc" -Credential $credential
#>
function Get-QualysAMUser {

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [String]$Login,
        [parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential

    )

    $Body = @"
<?xml version="1.0" encoding="UTF-8" ?>
<ServiceRequest>
	<filters>
		<Criteria field="username" operator="EQUALS">$($Login)</Criteria>
	</filters>
	<preferences>
		<limitResults>500</limitResults>
	</preferences>
</ServiceRequest>
"@

    $RestSplat = @{
        RelativeUri = "qps/rest/2.0/search/am/user"
        Method      = 'POST'
        XmlBody     = $Body
        Credential  = $Credential
    }

    try {
        $Response = Invoke-QualysTagRestCall @RestSplat
        $Response.ServiceResponse.data.user
    }
    catch {
        Write-Error "Operation not successful: $($Response.ServiceResponse.responseErrorDetails)"
    }
}
