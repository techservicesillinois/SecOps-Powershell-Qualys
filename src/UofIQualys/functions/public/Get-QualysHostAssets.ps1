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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns',
            Justification = 'This is consistent with the vendors verbiage')]
    param (

    )

    process{

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = 'asset/ip/'
            Body = @{
                action = 'list'
                echo_request = '1'
            }
        }

        $Response = Invoke-QualysRestCall @RestSplat
        [array]$HostAssets = $Response.IP_LIST_OUTPUT.RESPONSE.IP_SET.IP_RANGE
        $HostAssets

    }
}
