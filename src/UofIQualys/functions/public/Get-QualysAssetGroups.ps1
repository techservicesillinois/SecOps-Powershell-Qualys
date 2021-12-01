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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
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
                show_attributes = 'OWNER_USER_NAME, TITLE, IP_SET, APPLIANCE_LIST'
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
        #This will return IP information for every asset group
        if(!($Identity)){
            $Index = 0
            $AssetGroupInfo = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP
            foreach ($ID in $AssetGroupInfo.ID) {
                $IPs = @()
                #If there are ranges get the ranges and add them to the IP array
                If($AssetGroupInfo.IP_SET[$Index].IP_RANGE){
                    $IPs += $AssetGroupInfo.IP_SET[$Index].IP_RANGE
                    #If there are IPs and ranges now add the IPs to the array with the ranges
                    If($AssetGroupInfo.IP_SET[$Index].IP){
                        $IPs += $AssetGroupInfo.IP_SET[$Index].IP
                    }
                }
                #Sometimes there are only IPs and no ranges, add the IPs to the array
                ElseIf($AssetGroupInfo.IP_SET[$Index].IP){
                    $IPs += $AssetGroupInfo.IP_SET[$Index].IP
                }
                $AssetGroup = [PSCustomObject]@{
                    ID = $ID
                    Title = $AssetGroupInfo.TITLE.'#cdata-section'[$Index]
                    IP_Range = $IPs
                    DefaultScanner = $AssetGroupInfo.DEFAULT_APPLIANCE_ID[$Index]
                }
                $Index++
                $AssetGroup
            }
        }
        #Get the IPs for if a single asset group identity is provided with the same logic as above
        else{
            $IPs = @()
            $AssetGroupInfo = $Response.ASSET_GROUP_LIST_OUTPUT.RESPONSE.ASSET_GROUP_LIST.ASSET_GROUP
            If($AssetGroupInfo.IP_SET.IP_RANGE){
                $IPs += $AssetGroupInfo.IP_SET.IP_RANGE
                If($AssetGroupInfo.IP_SET.IP){
                    $IPs += $AssetGroupInfo.IP_SET.IP
                }
            }
            ElseIf($AssetGroupInfo.IP_SET.IP){
                $IPs += $AssetGroupInfo.IP_SET.IP
            }
            $AssetGroup = [PSCustomObject]@{
                ID = $AssetGroupInfo.ID
                Title = $AssetGroupInfo.TITLE.'#cdata-section'
                IP_Range = $IPs
                DefaultScanner = $AssetGroupInfo.DEFAULT_APPLIANCE_ID
            }
            If(!($AssetGroup.ID))
                {
                    Throw "No Asset Group found matching the title or ID $($Identity)"
                    Exit
                }
            $AssetGroup
        }
    }
}
