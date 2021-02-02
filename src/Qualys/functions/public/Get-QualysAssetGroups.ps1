<#
.Synopsis
    Returns one or all Asset Groups in Qualys
.DESCRIPTION
    Returns one or all Asset Groups in Qualys
.PARAMETER Identity
    The Title or ID of the Asset Group in Qualys
.PARAMETER Limit
    Number of items to return. By default this is 0 (all)
.EXAMPLE
    Get-QualysAssetGroups
    Returns all Asset Groups
.EXAMPLE
    Get-QualysAssetGroups -Identity "7270750"
    Returns the Asset Group with this ID
.EXAMPLE
    Get-QualysAssetGroups -Identity "Test"
    Returns the Asset Group titled "Test"
    #>
function Get-QualysAssetGroups{
    [CmdletBinding()]
    param (
        [String]$Identity,
        [int]$Limit = 0
    )

    process{

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = 'asset/group/'
            Body = @{
                action = 'list'
                echo_request = '1'
                truncation_limit = $Limit
            }
        }

        #Check if a name or ID is provided and add it to the Body hashtable
        If($Identity){
            If($Identity -match '\D'){
                $RestSplat.Body['title'] = $Identity
            }
            Else{
                $RestSplat.Body['ids'] = $Identity
            }
        }

        $Response = Invoke-QualysRestCall @RestSplat
        if(!($Identity)){
            $Index = 0
            foreach ($ID in $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.ID ) {
                $IPs = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.IP_SET.IP_RANGE ?
                    $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.IP_SET.IP_RANGE :
                    $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.IP_SET.IP
                $AssetGroup = [PSCustomObject]@{
                    ID = $ID
                    Title = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.TITLE.'#cdata-section'[$Index]
                    IP_Range = $IPs
                    DefaultScanner = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.DEFAULT_APPLIANCE_ID
                }
                $Index++
                $AssetGroup
            }
        }
        else{
            $IPs = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.IP_SET.IP_RANGE ?
                $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.IP_SET.IP_RANGE :
                $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.IP_SET.IP
            $AssetGroup = [PSCustomObject]@{
                ID = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.ID
                Title = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.TITLE.'#cdata-section'
                IP_Range = $IPs
                DefaultScanner = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.DEFAULT_APPLIANCE_ID
            }
            $AssetGroup
        }
    }
}
