<#
.Synopsis
    Adds an Asset Group to Qualys
.DESCRIPTION
    Adds an Asset Group to Qualys
.PARAMETER Title
    The Title of the Asset Group
.PARAMETER Title
    Comma separated IP ranges to add to new asset group. Ex "128.174.118.0-128.174.118.255, 130.126.127.32-130.126.127.63"
.EXAMPLE
    Add-QualysAssetGroups -Title "My Asset Group"
    Returns all Asset Groups
    #>
    function Add-QualysAssetGroups{
        [CmdletBinding()]
        param (
            [Parameter(Mandatory=$true)]
            [String]$Title,
            [string]$IPs
        )

        process{

            $Method = 'POST'
            $RelativeURI = 'asset/group/'
            $Body = @{
                action = 'add'
                echo_request = '1'
                title = $Title
            }

            If($IPs){
                $Body['ips'] = $IPs
            }

            $Response = Invoke-QualysRestCall -RelativeURI $RelativeURI -Method $Method -Body $Body
            $Response.SIMPLE_RETURN.RESPONSE.TEXT

            }

    }
