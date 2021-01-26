<#
.Synopsis
    Returns users from Qualys
.DESCRIPTION
    Returns users from Qualys
.PARAMETER Credential
    This API call only supports basic HTTP authentication. You must provide your credentials separately for this function.
.PARAMETER ExternalID
    Specifies user accounts with an external ID value that contains this string
.EXAMPLE
    Get-QualysUser
#>
function Get-QualysUser{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential,
        [String]$ExternalID
    )

    process{

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = 'msp/user_list.php'
            Credential = $Credential
            Body = @{
                external_id_contains = $ExternalID
            }
        }

        $Response = Invoke-QualysRestCall @RestSplat
        $Response.USER_LIST_OUTPUT.USER_LIST.USER
    }
}
