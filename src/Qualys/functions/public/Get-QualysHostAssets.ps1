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

        $HostAssetSplat = @{
            Headers = @{
                'X-Requested-With'='powershell'
            }
            Method = 'GET'
            URI = "$($Script:Settings.BaseURI)asset/ip/"
            Body = @{
                action = 'list'
                echo_request = '1'
            }
            WebSession = $Script:Session
        }

        $Response = Invoke-RestMethod  @HostAssetSplat
        [array]$HostAssets = $Response.IP_LIST_OUTPUT.RESPONSE.IP_SET.IP_RANGE
        $HostAssets

    }
}