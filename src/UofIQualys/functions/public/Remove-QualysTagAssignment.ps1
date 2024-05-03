function Remove-QualysTagAssignment {
    <#
        .SYNOPSIS
            Removes a tag from an asset in Qualys.
        .DESCRIPTION
            This function takes an asset ID and a tag ID and removes the tag from the asset.
        .PARAMETER assetId
            The ID of the asset to remove the tag from.
        .PARAMETER tagId
            The ID of the tag to remove from the asset.
        .PARAMETER inputCredential
            The credential object to log into Qualys. By default, this is set to the global variable $Credential.
        .PARAMETER inputQualysApiUrl
            The URL of the Qualys API. By default, this is set to the global variable $qualysApiUrl.
        .EXAMPLE
            $credential = Get-Credential
            Remove-QualysTagAssignment -assetId "12345" -tagId "67890"
            # We don't know the asset ID or tag ID, so we use the Get-QualysAsset and Get-QualysTag functions to get them.
            Remove-QualysTagAssignment -assetId (Get-QualysAsset -assetName "Server1").id -tagId (Get-QualysTag -tagName "Managed Linux").id
        .NOTES
            Authors:
            - Carter Kindley
    #>
    param (
        [parameter(Mandatory = $true)]
        [string]
        $AssetId,
        [parameter(Mandatory = $true)]
        [string]
        $TagId,
        [PSCredential]
        $InputCredential = $Credential,
        [string]
        $InputQualysApiUrl = $qualysApiUrl
    )

    # If any of the non-mandatory parameters are not provided, return error and state which ones are empty
    if ([string]::IsNullOrEmpty($inputQualysApiUrl) -or [string]::IsNullOrEmpty($inputCredential.UserName) -or [string]::IsNullOrEmpty($inputCredential.GetNetworkCredential().Password)) {
        return "One or more of the following parameters are empty: InputCredential, InputQualysApiUrl.
        By default, these parameters are set to the values of the global variables: Credential, QualysApiUrl.
        Please ensure these global variables are set, or provide the inputs, and try again."
    }

    $bodyRemoveTag = "<ServiceRequest>
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

    Write-Verbose "Making API request to remove tag $tagId from asset $assetId."

    # Store progress preference and set to SilentlyContinue
    $origProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    $responseRemoveTag = Invoke-WebRequest -UseBasicParsing -Uri "$inputQualysApiUrl/qps/rest/2.0/update/am/hostasset/$assetId" -ErrorAction Continue -Method Post -Headers @{
        "Authorization" = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($InputCredential.UserName)`:$($InputCredential.GetNetworkCredential().Password)")))"
        "Content-Type"  = "application/xml"
        "Accept"        = "application/xml"
    } -Body $bodyRemoveTag

    # Restore progress preference
    $ProgressPreference = $origProgressPreference

    # If response is an HTTP error code, return error
    if ($responseRemoveTag.StatusCode -ne 200) {
        return "Error removing tag $tagId from asset $assetId. HTTP status code: $($responseRemoveTag.StatusCode)."
    }
    else {
        Write-Verbose "Tag $tagId removed from asset $assetId."
        return $null
    }
}
