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
        .PARAMETER tagName
            The name of the tag by which to retrieve all associated hosts.
        .PARAMETER inputCredential
            The credential object to log into Qualys. By default, this is set to the global variable $Credential.
        .PARAMETER inputQualysApiUrl
            The URL of the Qualys API. By default, this is set to the global variable $qualysApiUrl.
        .EXAMPLE
            Get-QualysAsset -assetName "Server1"
            $asset = Get-QualysAsset -assetName "Server1" -inputCredential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue) -inputQualysApiUrl "https://qualysapi.qg2.apps.qualys.com"
            $asset.id # returns the asset ID
            $asset = Get-QualysAsset -assetId "123456789" -inputCredential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue) -inputQualysApiUrl "https://qualysapi.qg3.apps.qualys.com"
            $assets = Get-QualysAsset -TagName "Important" -InputCredential $inputcredential -InputQualysApiUrl $inputQualysApiUrl
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
        [Int32]
        $AssetId,

        [Parameter(ParameterSetName='tagName', Mandatory=$true)]
        [string]
        $TagName,

        [string]
        $TagPrefix,

        [PScredential]
        $InputCredential = $Credential,

        [string]
        $InputQualysApiUrl = $QualysApiUrl
    )

    # If any of the non-mandatory parameters are not provided, return error and state which ones are empty
    if ( [string]::IsNullOrEmpty($InputQualysApiUrl) -or [string]::IsNullOrEmpty($InputCredential.UserName) -or [string]::IsNullOrEmpty($InputCredential.GetNetworkCredential().Password) ) {
        throw "One or more of the following parameters are empty: inputCredential, inputQualysApiUrl.
        By default, these parameters are set to the values of the global variables: username, keyvault, secretName, qualysApiUrl.
        Please ensure these global variables are set, or provide the inputs, and try again."
    }

# Create a hashtable that maps parameter set names to parameter values
$ParameterMap = @{
    'name' = $AssetName
    'id' = $AssetId
    'tagName' = $TagName
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
            "Authorization" = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($InputCredential.UserName)`:$($InputCredential.GetNetworkCredential().Password)")))"
            "Content-Type"  = "application/xml"
            "Accept"        = "application/xml"
        } -Body $bodyAsset).Content

    if ($null -eq $responseContent.ServiceResponse.data.HostAsset) {
        return $null
    }

    $responseAssets = New-Object System.Collections.Generic.List[QualysAsset]

    foreach ($asset in $responseContent.ServiceResponse.data.HostAsset) {
        $responseAssets.Add( # Create new QualysAsset and add connection info before adding to $assets list
            ([QualysAsset]::new($asset) | Add-Member -MemberType NoteProperty -Name "qualysApiUrl" -Value $InputQualysApiUrl -Force -PassThru | Add-Member -MemberType NoteProperty -Name "prefix" -Value $TagPrefix -Force -PassThru)
        )
    }

    # Restore progress preference
    $ProgressPreference = $origProgressPreference

    if ($responseAssets.Count -eq 1) {
        return $responseAssets[0]
    }

    # Return the asset object
    return $responseAssets

}
