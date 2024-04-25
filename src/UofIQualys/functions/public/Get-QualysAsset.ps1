function Get-QualysAsset {
    <#
        .SYNOPSIS
            Gets an asset from Qualys.
        .DESCRIPTION
            This function takes an asset name or ID and returns the asset object.
        .PARAMETER assetName
            The name of the asset to be retrieved.
        .PARAMETER assetId
            The ID of the asset to be retrieved.
        .PARAMETER inputUsername
            The username to log into Qualys. By default, this is set to the global variable $username.
        .PARAMETER inputKeyvault
            The name of the keyvault where the Qualys password is stored. By default, this is set to the global variable $keyvault.
        .PARAMETER inputSecretName
            The name of the secret in the keyvault where the Qualys password is stored. By default, this is set to the global variable $secretName.
        .PARAMETER inputQualysApiUrl
            The URL of the Qualys API. By default, this is set to the global variable $qualysApiUrl.
        .EXAMPLE
            Get-QualysAsset -assetName "Server1"
            $asset = Get-QualysAsset -assetName "Server1" -inputUsername "admin" -inputKeyvault "MyAzKeyVault" -inputSecretName "qualys-password" -inputQualysApiUrl "https://qualysapi.qg2.apps.qualys.com"
            $asset.id # returns the asset ID
            $asset = Get-QualysAsset -assetId "123456789" -inputUsername "admin" -inputKeyvault "MyAzKeyVault" -inputSecretName "qualys-password" -inputQualysApiUrl "https://qualysapi.qg3.apps.qualys.com"
        .NOTES
            Authors:
            - Carter Kindley
    #>
    [CmdletBinding(DefaultParameterSetName='name')]
    param (
        [Parameter(ParameterSetName='name', Mandatory=$true)]
        [string]
        $AssetName,

        [Parameter(ParameterSetName='id', Mandatory=$true)]
        [string]
        $AssetId,

        [string]
        $InputUsername = $Username,
        [string]
        $InputKeyvault = $Keyvault,
        [string]
        $InputSecretName = $SecretName,
        [string]
        $InputQualysApiUrl = $QualysApiUrl
    )

    # If any of the non-mandatory parameters are not provided, return error and state which ones are empty
    if ([string]::IsNullOrEmpty($InputUsername) -or [string]::IsNullOrEmpty($InputKeyvault) -or [string]::IsNullOrEmpty($InputSecretName) -or [string]::IsNullOrEmpty($InputQualysApiUrl)) {
        return "One or more of the following parameters are empty: inputUsername, inputKeyvault, inputSecretName, inputQualysApiUrl.
        By default, these parameters are set to the values of the global variables: username, keyvault, secretName, qualysApiUrl.
        Please ensure these global variables are set, or provide the inputs, and try again."
    }

# Create a hashtable that maps parameter set names to parameter values
$ParameterMap = @{
    'name' = $AssetName
    'id' = $AssetId
}

# Get the value for the current parameter set
$ParameterValue = $ParameterMap[$PSCmdlet.ParameterSetName]

# Build bodyAsset, filtering on either assetName or assetId, depending on which was provided
$bodyAsset = "<ServiceRequest>
    <filters>
        <Criteria field=""$($PSCmdlet.ParameterSetName)"" operator=""EQUALS"">$ParameterValue</Criteria>
    </filters>
</ServiceRequest>"

    Write-Verbose "Making API request for asset $assetName."

    # Store progress preference and set to SilentlyContinue
    $origProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    #need to return null if no asset is found

    $responseContent = [xml](Invoke-WebRequest -UseBasicParsing -Uri "$InputQualysApiUrl/qps/rest/2.0/search/am/hostasset" -ErrorAction Continue -Method Post -Headers @{
            "Authorization" = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$InputUsername`:$(([PSCredential]::new('admin', ((Get-AzKeyVaultSecret -VaultName $InputKeyvault -Name "$InputSecretName").SecretValue)).GetNetworkCredential().Password))")))"
            "Content-Type"  = "application/xml"
            "Accept"        = "application/xml"
        } -Body $bodyAsset).Content

    if ($null -eq $responseContent.ServiceResponse.data.HostAsset) {
        return $null
    }

    $responseAsset = [QualysAsset]::new($responseContent.ServiceResponse.data.HostAsset)


    # Restore progress preference
    $ProgressPreference = $origProgressPreference

    # Stash non-secret connection info in new object
    $responseAsset.username = $InputUsername
    $responseAsset.keyvault = $InputKeyvault
    $responseAsset.qualysApiUrl = $InputQualysApiUrl
    $responseAsset.secretName = $InputSecretName

    # Return the asset object
    return $responseAsset

}
