<#
.Synopsis
    Removes an Asset Group to Qualys
.DESCRIPTION
    Removes an Asset Group to Qualys
.PARAMETER Identity
    The Title or ID of the Asset Group to delete. Only one Identity may be provided per API call.
.EXAMPLE
    Remove-QualysAssetGroups -Identity "My Asset Group"
    #>
    function Remove-QualysAssetGroups{
        [CmdletBinding(SupportsShouldProcess)]
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
        param (
            [Parameter(Mandatory=$true)]
            [String]$Identity
        )

        process{
            if ($PSCmdlet.ShouldProcess($Identity)){
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
                    If($Identity -match '\D'){
                        $RestSplat.Body['id'] = (Get-QualysAssetGroups -Identity $Identity).Id
                    }
                    Else{
                        $RestSplat.Body['id'] = $Identity
                    }
                }

                $Response = Invoke-QualysRestCall @RestSplat
                if ($Response) {
                    Write-Verbose -Message $Response.SIMPLE_RETURN.RESPONSE.TEXT
                }
            }
        }
    }
