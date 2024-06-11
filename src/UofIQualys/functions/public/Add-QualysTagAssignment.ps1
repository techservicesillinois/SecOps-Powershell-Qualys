function Add-QualysTagAssignment {
    <#
        .SYNOPSIS
            Adds a tag to an asset in Qualys.
        .DESCRIPTION
            This function takes an asset ID and a tag ID and adds the tag to the asset.
        .PARAMETER assetId
            The ID of the asset to add the tag to.
        .PARAMETER tagId
            The ID of the tag to add to the asset.
        .PARAMETER Credential
            The credential object to log into Qualys.
        .EXAMPLE
            Add-QualysTagAssignment -assetId "12345" -tagId "67890" -Credential $credential

            ### We don't know the asset ID or tag ID, so we use the Get-QualysAsset and Get-QualysTag functions to get them.
            Add-QualysTagAssignment -assetId (Get-QualysAsset -assetName "Server1").id -tagId (Get-QualysTag -tagName "Managed Linux").id -Credential $credential

        .NOTES
            The easiest way to get the asset ID is to use the Get-QualysAsset function.
            The easiest way to get the tag ID is to use the Get-QualysTag function.
            You can combine these operations as shown in the example.
    #>
    param (

        [parameter(Mandatory = $true)]
        [Int32]
        $AssetId,

        [parameter(Mandatory = $true)]
        [Int32]
        $TagId,

        [parameter(Mandatory = $true)]
        [PSCredential]
        $Credential

    )

    $bodyAddTag = "<ServiceRequest>
                        <data>
                            <HostAsset>
                                <tags>
                                    <add>
                                        <TagSimple>
                                            <id>$tagId</id>
                                        </TagSimple>
                                    </add>
                                </tags>
                            </HostAsset>
                        </data>
                    </ServiceRequest>"

    # Store progress preference and set to SilentlyContinue
    $origProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    $RestSplat = @{
        RelativeUri = "qps/rest/2.0/update/am/hostasset/$assetId"
        Method      = 'POST'
        XmlBody     = $bodyAddTag
        Credential  = $Credential
    }

    try {
        $responseAddTag = Invoke-QualysRestCall @RestSplat
    }
    catch {
        # Dig into the exception to get the Response details.
        # Note that value__ is not a typo.
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
        $ProgressPreference = $origProgressPreference
        return "Error adding tag $tagId from asset $assetId."
    }

    # Restore progress preference
    $ProgressPreference = $origProgressPreference

        return $null

}
