<#
.Synopsis
    Edits an Asset Group to Qualys
.DESCRIPTION
    Edits an Asset Group to Qualys
.PARAMETER Identity
    The ID or Title of the asset group you want to edit
.PARAMETER Title
    Edits the Title of the Asset Group
.PARAMETER SetIPs
    Removes any pre-existing IPs assigned. Comma separated IP ranges to assign to asset group. Ex "128.174.118.0-128.174.118.255", "192.168.0.1/24"
.PARAMETER AddIPs
    Comma separated IP ranges to add to asset group. Ex "128.174.118.0-128.174.118.255", "192.168.0.1/24"
.PARAMETER RemoveIPs
    Comma separated IP ranges to remove from asset group. Ex "128.174.118.0-128.174.118.255", "192.168.0.1/24"
.PARAMETER Comments
    Description or comments about the group; max 255 characters
.PARAMETER Division
    The Division of the Asset Group, typically the Owner Code from CDB
.EXAMPLE
    Set-QualysAssetGroups -Identity '7445535' -Title "My Edited Asset Group Title"
.EXAMPLE
    Set-QualysAssetGroups -Identity "My Asset Group" -IPs "192.168.0.1/24"
    #>
    function Set-QualysAssetGroups{
        [CmdletBinding()]
        param (
            [Parameter(Mandatory=$true)]
            [String]$Identity,
            [String]$Title,
            [String[]]$SetIPs,
            [String[]]$AddIPs,
            [String[]]$RemoveIPs,
            [String]$Comments,
            [String]$Division
        )

        process{

            $RestSplat = @{
                Method = 'POST'
                RelativeURI = 'asset/group/'
                Body = @{
                    action = 'edit'
                    echo_request = '1'
                }
            }

            #Check if a name or ID is provided and add it to the Body hashtable
            If($Identity){
                If($Identity -match '\D'){
                    $RestSplat.Body['id'] = (Get-QualysAssetGroups -Identity $Identity).Id
                }
                Else{
                    $RestSplat.Body['id'] = $Identity
                }
            }

            If($SetIPs){
                $RestSplat.Body['set_ips'] = ($SetIPs.Trim() -join ", ")
            }

            If($AddIPs){
                $RestSplat.Body['add_ips'] = ($AddIPs.Trim() -join ", ")
            }

            If($RemoveIPs){
                $RestSplat.Body['remove_ips'] = ($RemoveIPs.Trim() -join ", ")
            }

            If($Comments){
                $RestSplat.Body['set_comments'] = $Comments
            }

            If($Division){
                $RestSplat.Body['set_division'] = $Division
            }

            If($Division){
                $RestSplat.Body['set_title'] = $Title
            }

            $Response = Invoke-QualysRestCall @RestSplat
            if ($Response) {
                Write-Verbose -Message $Response.SIMPLE_RETURN.RESPONSE.TEXT
            }
        }
    }
