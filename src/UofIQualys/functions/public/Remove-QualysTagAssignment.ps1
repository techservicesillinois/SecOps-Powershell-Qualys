function Remove-QualysTagAssignment {
    <#
        .SYNOPSIS
            Removes a tag from an asset in Qualys.
        .DESCRIPTION
            This function takes an asset ID and a tag ID and removes the tag from the asset.
        .PARAMETER AssetId
            The ID of the asset to remove the tag from.
        .PARAMETER TagId
            The ID of the tag to remove from the asset.
        .PARAMETER Credential
            The credential object to log into Qualys.
        .EXAMPLE
            $credential = Get-Credential
            Remove-QualysTagAssignment -assetId "12345" -tagId "67890" -Credential $credential
            # We don't know the asset ID or tag ID, so we use the Get-QualysAsset and Get-QualysTag functions to get them.
            Remove-QualysTagAssignment -assetId (Get-QualysAsset -assetName "Server1").id -tagId (Get-QualysTag -tagName "Managed Linux").id -Credential $credential
    #>
    [OutputType('System.String')]
    [CmdletBinding(SupportsShouldProcess)]
    param (

        [parameter(Mandatory = $true)]
        [string]
        $AssetId,

        [parameter(Mandatory = $true)]
        [Int32]
        $TagId,

        [parameter(Mandatory = $true)]
        [PSCredential]
        $Credential

    )

    if ($PSCmdlet.ShouldProcess("Asset ID: $AssetId, Tag ID: $TagId")) {
        $BodyRemoveTag = "<ServiceRequest>
                        <data>
                            <HostAsset>
                                <tags>
                                    <remove>
                                        <TagSimple>
                                            <id>$TagId</id>
                                        </TagSimple>
                                    </remove>
                                </tags>
                            </HostAsset>
                        </data>
                    </ServiceRequest>"

        # Store progress preference and set to SilentlyContinue
        $origProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'

        $RestSplat = @{
            RelativeUri = "qps/rest/2.0/update/am/hostasset/$AssetId"
            Method      = 'POST'
            XmlBody     = $BodyRemoveTag
            Credential  = $Credential
        }

        try {
            Invoke-QualysRestCall @RestSplat
        }
        catch {
            # Dig into the exception to get the Response details.
            # Note that value__ is not a typo.
            Write-Verbose "StatusCode:" $_.Exception.Response.StatusCode.value__
            Write-Verbose "StatusDescription:" $_.Exception.Response.StatusDescription
            $ProgressPreference = $OrigProgressPreference
            return "Error removing tag $tagId from asset $assetId."
        }
        $ProgressPreference = $OrigProgressPreference
        return $null
    }
}
