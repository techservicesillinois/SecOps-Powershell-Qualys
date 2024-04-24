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
        .PARAMETER inputUsername
            The username to log into Qualys. By default, this is set to the global variable $username.
        .PARAMETER inputKeyvault
            The name of the keyvault where the Qualys password is stored. By default, this is set to the global variable $keyvault.
        .PARAMETER inputSecretName
            The name of the secret in the keyvault where the Qualys password is stored. By default, this is set to the global variable $secretName.
        .PARAMETER inputQualysApiUrl
            The URL of the Qualys API. By default, this is set to the global variable $qualysApiUrl.
        .EXAMPLE
            Add-QualysTagAssignment -assetId "12345" -tagId "67890"

            ### We don't know the asset ID or tag ID, so we use the Get-QualysAsset and Get-QualysTag functions to get them.
            Add-QualysTagAssignment -assetId (Get-QualysAsset -assetName "Server1").id -tagId (Get-QualysTag -tagName "Managed Linux").id

        .NOTES
            Authors:
            - Carter Kindley

            The easiest way to get the asset ID is to use the Get-QualysAsset function.
            The easiest way to get the tag ID is to use the Get-QualysTag function.
            You can combine these operations as shown in the example.
    #>
    param (
        [parameter(Mandatory = $true)]
        [string]
        $assetId,
        [parameter(Mandatory = $true)]
        [string]
        $tagId,
        [string]
        $inputUsername = $username,
        [string]
        $inputKeyvault = $keyvault,
        [string]
        $inputSecretName = $secretName,
        [string]
        $inputQualysApiUrl = $qualysApiUrl
    )

    # If any of the non-mandatory parameters are not provided, return error and state which ones are empty
    if ([string]::IsNullOrEmpty($inputUsername) -or [string]::IsNullOrEmpty($inputKeyvault) -or [string]::IsNullOrEmpty($inputSecretName) -or [string]::IsNullOrEmpty($inputQualysApiUrl)) {
        return "One or more of the following parameters are empty: inputUsername, inputKeyvault, inputSecretName, inputQualysApiUrl.
        By default, these parameters are set to the values of the global variables: username, keyvault, secretName, qualysApiUrl.
        Please ensure these global variables are set, or provide the inputs, and try again."
    }

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

    Write-Verbose "Making API request to add tag $tagId to asset $assetId."

    # Store progress preference and set to SilentlyContinue
    $origProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    $responseAddTag = Invoke-WebRequest -UseBasicParsing -Uri "$inputQualysApiUrl/qps/rest/2.0/update/am/hostasset/$assetId" -ErrorAction Continue -Method Post -Headers @{
        "Authorization" = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$inputUsername`:$(([PSCredential]::new('admin', ((Get-AzKeyVaultSecret -VaultName $inputKeyvault -Name "$inputSecretName").SecretValue)).GetNetworkCredential().Password))")))"
        "Content-Type"  = "application/xml"
        "Accept"        = "application/xml"
    } -Body $bodyAddTag

    # Restore progress preference
    $ProgressPreference = $origProgressPreference

    # If response is an HTTP error code, return error
    if ($responseAddTag.StatusCode -ne 200) {
        return "Error adding tag $tagId to asset $assetId. HTTP status code: $($responseAddTag.StatusCode)."
    }
    else {
        Write-Verbose "Tag $tagId added to asset $assetId."
        return $null
    }
}
