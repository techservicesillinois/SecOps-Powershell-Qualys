<#
.Synopsis
    Returns an array of all host assets (IPs) in Qualys
.DESCRIPTION
    Returns an array of all host assets (IPs) in Qualys
.EXAMPLE
    Get-QualysHostAssets
    #>
function Get-QualysHostAssets{
    [CmdletBinding()]
    param (

    )

    process{

        $Method = 'GET'
        $RelativeURI = 'asset/ip/'
        $Body = @{
            action = 'list'
            echo_request = '1'
        }

        $Response = Invoke-QualysRestCall -RelativeURI $RelativeURI -Method $Method -Body $Body
        [array]$HostAssets = $Response.IP_LIST_OUTPUT.RESPONSE.IP_SET.IP_RANGE
        $HostAssets

    }
}