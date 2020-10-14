<#
.Synopsis
    Adds one or more networks into Qualys Host Assets
.DESCRIPTION
    Adds one or more networks into Qualys Host Assets
.PARAMETER Networks
    Comma separated string of networks by IP range (192.168.0.1-192.168.0.254) or CIDR notation (192.168.0.1/24)
.EXAMPLE
    Add-QualysHostAssets -Credential $Credential -Networks $Networks
#>
function Add-QualysHostAssets{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Networks
    )

    process{

        #add foreach networks loop here
        $HostAssetSplat = @{
            Headers = @{
                'X-Requested-With'='powershell'
            }
            Method = 'POST'
            URI = "$($Script:Settings.BaseURI)asset/ip/"
            Body = @{
                action = 'add'
                echo_request = '1'
                ips = $Networks
                enable_vm = '1'
            }
            WebSession = $Script:Session
        }

        $Response = Invoke-RestMethod  @HostAssetSplat
        $Response.SIMPLE_RETURN.RESPONSE.TEXT
    }
}