<#
    .SYNOPSIS
        Adds a tag to an user in Qualys.
    .DESCRIPTION
        This function takes a User ID and a Tag name and adds the tag to the user.
    .PARAMETER UserID
        The ID of the user to add the tag to.
    .PARAMETER Tags
        An array of Names or IDs of tags to add to the user.
    .PARAMETER Credential
        The credential object to log into Qualys.
    .EXAMPLE
        Add-QualysTagAssignment -UserID "566158438" -Tag "0001-ctav-net_CDB-7725" -Credential $credential
    .NOTES
        The easiest way to get the UserID is to use the Get-QualysUser function.
        The easiest way to get the tag ID is to use the Get-QualysTag function.
#>
function Add-QualysUserTagAssignment {

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [Int64]$UserId,
        [parameter(Mandatory = $true)]
        [String[]]$Tags,
        [parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential

    )

    If($Tags[0] -match '\D'){
        $NameOrID = "name"
    }
    Else{
        $NameOrID = "id"
    }

    $TagXml = $Tags | ForEach-Object {
        "<TagData>
        <$NameOrID>$_</$NameOrID>
        </TagData>"
    }

    $Body = @"
<?xml version="1.0" encoding="UTF-8" ?>
<ServiceRequest>
    <data>
        <User>
            <scopeTags>
                <add>
                        $($TagXml -join "`n")
                </add>
            </scopeTags>
        </User>
    </data>
</ServiceRequest>
"@

    $RestSplat = @{
        RelativeUri = "qps/rest/2.0/update/am/user/$($UserID)"
        Method      = 'POST'
        XmlBody     = $Body
        Credential  = $Credential
    }

    try {
        $Response = Invoke-QualysTagRestCall @RestSplat
        Write-Verbose $Response.ServiceResponse.responseCode
    }
    catch {
        Write-Error "Operation not successful: $($Response.ServiceResponse.responseErrorDetails)"
    }
}
