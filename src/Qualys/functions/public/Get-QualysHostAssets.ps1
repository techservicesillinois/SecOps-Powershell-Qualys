<#
.Synopsis
    Returns an array of all host assets (IPs) in Qualys
.DESCRIPTION
    Returns an array of all host assets (IPs) in Qualys
.PARAMETER Cookie
    Cookie generated with Get-QualysCookie
.EXAMPLE
    $Cookie = Get-QualysCookie -Credential $Credential
    [array]$HostAssets = Get-QualysHostAssets -Cookie $Cookie
#>
function Get-QualysHostAssets{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [WebRequestSession]$Cookie
    )

    process{

        $HostAssetSplat = @{
            Headers = @{
                'X-Requested-With'='powershell'
            }
            Method = 'GET'
            URI = "$($BaseURI)asset/ip/"
            Body = @{
                action = 'list'
                echo_request = '1'
            }
            WebSession = $Cookie
        }

        $Response = Invoke-RestMethod  @HostAssetSplat
        [array]$HostAssets = $Response.IP_LIST_OUTPUT.RESPONSE.IP_SET.IP_RANGE
        $HostAssets

    }
}