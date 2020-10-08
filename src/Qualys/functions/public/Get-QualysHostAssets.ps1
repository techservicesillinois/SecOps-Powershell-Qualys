<#
.Synopsis
    Returns an array of all host assets (IPs) in Qualys
.DESCRIPTION
    Returns an array of all host assets (IPs) in Qualys
.PARAMETER Credential
    Credentials used to authenticate to Qualys
.EXAMPLE
    Get-QualysHostAssets -Credential $Credential
#>
function Get-QualysHostAssets{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Credential
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
            WebSession = Get-QualysCookie -Credential $Credential
        }

        $Response = Invoke-RestMethod  @HostAssetSplat
        [array]$HostAssets = $Response.IP_LIST_OUTPUT.RESPONSE.IP_SET.IP_RANGE
        $HostAssets

    }
}