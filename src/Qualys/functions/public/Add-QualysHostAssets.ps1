<#
.Synopsis
    Adds one or more networks into Qualys Host Assets
.DESCRIPTION
    Adds one or more networks into Qualys Host Assets
.PARAMETER Networks
    Comma separated string of networks by IP range (192.168.0.1-192.168.0.254) or CIDR notation (192.168.0.1/24)
.EXAMPLE
    Add-QualysHostAssets -Networks "128.174.118.0-128.174.118.255, 192.168.0.1/24"
#>
function Add-QualysHostAssets{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        #QOL Improvement to use string array
        #Why aren't you taking strings
        [String]$Networks
    )

    process{

        $RestSplat = @{
            Method = 'POST'
            RelativeURI = 'asset/ip/'
            Body = @{
                action = 'add'
                echo_request = '1'
                ips = $Networks
                enable_vm = '1'
            }
        }

        $Response = Invoke-QualysRestCall @RestSplat
        $Response.SIMPLE_RETURN.RESPONSE.TEXT
    }
}
