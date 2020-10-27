<#
.Synopsis
    Adds an Asset Group to Qualys
.DESCRIPTION
    Adds an Asset Group to Qualys
.PARAMETER Title
    The Title of the Asset Group
.PARAMETER IPs
    Comma separated IP ranges to add to new asset group. Ex "128.174.118.0-128.174.118.255", "192.168.0.1/24"
.PARAMETER Comments
    Description or comments about the group; max 255 characters
.PARAMETER Division
    The Division of the Asset Group, typically the Owner Code from CDB
.EXAMPLE
    Add-QualysAssetGroups -Title "My Asset Group"
.EXAMPLE
    Add-QualysAssetGroups -Title "My Asset Group" -IPs "192.168.0.1/24"
    #>
    function Add-QualysAssetGroups{
        [CmdletBinding()]
        param (
            [Parameter(Mandatory=$true)]
            [String]$Title,
            [string[]]$IPs,
            [string]$Comments,
            [string]$Division
        )

        process{

            $RestSplat = @{
                Method = 'POST'
                RelativeURI = 'asset/group/'
                Body = @{
                    action = 'add'
                    echo_request = '1'
                    title = $Title
                }
            }

            If($IPs){
                $IPs = $IPs -join ", "
                $IPs.Trim()
                $RestSplat.Body['ips'] = $IPs
            }

            If($Comments){
                $RestSplat.Body['comments'] = $Comments
            }

            If($Division){
                $RestSplat.Body['division'] = $Division
            }

            $Response = Invoke-QualysRestCall @RestSplat
            $Response.SIMPLE_RETURN.RESPONSE.TEXT

            }

    }
