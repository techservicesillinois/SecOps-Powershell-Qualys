<#
.Synopsis
    Returns one or all Asset Groups in Qualys
.DESCRIPTION
    Returns one or all Asset Groups in Qualys
.PARAMETER Identity
    The Title or ID of the Asset Group in Qualys
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
        [String]$Identity
    )

    process{

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = 'asset/group/'
            Body = @{
                action = 'list'
                echo_request = '1'
            }
        }

        #Check if a name or ID is provided and add it to the Body hashtable
        If($Identity){
            If($Identity -match '\d{5}'){
                $RestSplat.Body['ids'] = $Identity
            }
            Else{
                $RestSplat.Body['title'] = $Identity
            }
        }

        $Response = Invoke-QualysRestCall @RestSplat
        if(!($Identity)){
            $Index = 0
            foreach ($ID in $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.ID ) {
                $AssetGroup = [PSCustomObject]@{
                    ID = $ID
                    Title = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.TITLE.'#cdata-section'[$Index]
                    IP_Range = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.IP_SET[$Index].IP_RANGE
                }
                $Index++
                $AssetGroup
            }
        }
        else{
            $AssetGroup = [PSCustomObject]@{
                ID = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.ID
                Title = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.TITLE.'#cdata-section'
                IP_Range = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP.IP_SET.IP_RANGE
            }
            $AssetGroup
        }
    }
}
