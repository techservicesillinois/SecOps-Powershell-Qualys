function Get-QualysAsset {
    <#
        .SYNOPSIS
            Gets an asset from Qualys.
        .DESCRIPTION
            This function takes an asset name or ID and returns the asset object.
        .PARAMETER AssetName
            The name of the asset to be retrieved.
        .PARAMETER AssetId
            The ID of the asset to be retrieved.
        .PARAMETER TagName
            The name of the tag by which to retrieve all associated hosts.
        .PARAMETER Credential
            The credential object to log into Qualys.
        .EXAMPLE
            Get-QualysAsset -assetName "Server1"
            $asset = Get-QualysAsset -assetName "Server1" -Credential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue)
            $asset.id # returns the asset ID
            $asset = Get-QualysAsset -assetId "123456789" -Credential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue)
            $assets = Get-QualysAsset -TagName "Important" -Credential $credential
    #>
    [CmdletBinding(DefaultParameterSetName='name')]
    param (
        [Parameter(ParameterSetName='name', Mandatory=$true)]
        [string]
        $AssetName,

        [Parameter(ParameterSetName='id', Mandatory=$true)]
        [Int64]
        $AssetId,

        [Parameter(ParameterSetName='tagName', Mandatory=$true)]
        [string]
        $TagName,

        [string]
        $TagPrefix,

        [Parameter(Mandatory=$true)]
        [PScredential]
        $Credential

    )

# Create a hashtable that maps parameter set names to parameter values
$ParameterMap = @{
    'name' = $AssetName
    'id' = $AssetId
    'tagName' = $TagName
}

# Get the value for the current parameter set
$ParameterValue = $ParameterMap[$PSCmdlet.ParameterSetName]

# Build bodyAsset, filtering on either assetName or assetId, depending on which was provided
$BodyAsset = "<ServiceRequest>
    <filters>
        <Criteria field=""$($PSCmdlet.ParameterSetName)"" operator=""EQUALS"">$ParameterValue</Criteria>
    </filters>
</ServiceRequest>"

    Write-Verbose "Making API request for asset $assetName."

    # Store progress preference and set to SilentlyContinue
    $OrigProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    # Use Invoke-QualysTagRestCall to make the API request
    $RestSplat = @{
        Method = 'POST'
        RelativeURI = 'qps/rest/2.0/search/am/hostasset'
        XmlBody = $BodyAsset
        Credential = $Credential
    }

    $ResponseContent = [Xml](Invoke-QualysTagRestCall @RestSplat)

    if ($null -eq $ResponseContent.ServiceResponse.data.HostAsset) {
        return $null
    }

    $ResponseAssets = New-Object System.Collections.Generic.List[QualysAsset]

    foreach ($Asset in $ResponseContent.ServiceResponse.data.HostAsset) {
        $ResponseAssets.Add( # Create new QualysAsset and add connection info before adding to $assets list
            ([QualysAsset]::new($Asset) | Add-Member -MemberType NoteProperty -Name "prefix" -Value $TagPrefix -Force -PassThru)
        )
    }

    # Restore progress preference
    $ProgressPreference = $OrigProgressPreference

    if ($ResponseAssets.Count -eq 1) {
        return $ResponseAssets[0]
    }

    # Return the asset object
    return $ResponseAssets

}
