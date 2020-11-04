<#
.Synopsis
    Removes an Asset Group to Qualys
.DESCRIPTION
    Removes an Asset Group to Qualys
.PARAMETER Identity
    The Title or ID of the Asset Group to delete
.EXAMPLE
    Delete-QualysAssetGroups -Identity "My Asset Group"
    #>
    function Remove-QualysAssetGroups{
        [CmdletBinding()]
        param (
            [Parameter(Mandatory=$true)]
            [String]$Identity
        )

        process{

            $RestSplat = @{
                Method = 'POST'
                RelativeURI = 'asset/group/'
                Body = @{
                    action = 'delete'
                    echo_request = '1'
                }
            }

            #Check if a name or ID is provided and add it to the Body hashtable
            If($Identity){
                If($Identity -match '\d{5}'){
                    $RestSplat.Body['id'] = $Identity
                }
                Else{
                    $RestSplat.Body['id'] = (Get-QualysAssetGroups -Identity $Identity).ID
                }
            }

            $Response = Invoke-QualysRestCall @RestSplat
            $Response.SIMPLE_RETURN.RESPONSE.TEXT

            }
    }
