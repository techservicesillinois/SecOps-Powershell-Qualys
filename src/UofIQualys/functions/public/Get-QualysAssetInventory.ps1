function Get-QualysAssetInventory {
    <#
        .SYNOPSIS
            Gets the Qualys asset inventory.
        .DESCRIPTION
            This function retrieves the Qualys asset inventory. Batch size maximum defaults to 1000.
            By default, this returns an array of QualysAsset objects. By default, it returns all objects visible to the service account.
        .PARAMETER inputUsername
            The username to log into Qualys.
        .PARAMETER inputKeyvault
            The name of the keyvault where the Qualys password is stored.
        .PARAMETER inputSecretName
            The name of the secret in the keyvault where the Qualys password is stored.
        .PARAMETER inputQualysApiUrl
            The URL of the Qualys API.
        .PARAMETER batchSize
            The number of assets to retrieve in each batch. Default is 1000.
        .EXAMPLE
            $qInventory = Get-QualysAssetInventory -inputUsername "admin" -inputKeyvault "MyAzKeyVault" -inputSecretName "qualys-password" -inputQualysApiUrl "https://qualysapi.qg4.apps.qualys.com" -batchSize 500
        .NOTES
            Authors:
            - Carter Kindley
    #>

    param (
        [string]
        $inputUsername = $username,
        [string]
        $inputKeyvault = $keyvault,
        [string]
        $inputSecretName = $secretName,
        [string]
        $inputQualysApiUrl = $qualysApiUrl,
        [int]
        $batchSize = 1000
    )

    # Region full pull of all hosts

    $assets = New-Object System.Collections.Generic.List[QualysAsset]
    $lastId = 0

    while ($null -ne $lastId) {
        $bodyHost = "<ServiceRequest>
                        <preferences>
                            <limitResults>$batchSize</limitResults>
                        </preferences>
                        <filters>
                            <Criteria field=""id"" operator=""GREATER"">$lastId</Criteria>
                        </filters>
                    </ServiceRequest>"

        $origProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'

        $responseHostAdd = [xml]((Invoke-WebRequest -UseBasicParsing -Uri "$inputQualysApiUrl/qps/rest/2.0/search/am/hostasset" -Method Post -Headers @{
                    "Authorization" = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$inputUsername`:$(([PSCredential]::new('admin', ((Get-AzKeyVaultSecret -VaultName $inputkeyvault -Name "Qualys-API").SecretValue)).GetNetworkCredential().Password))")))"
                    "Content-Type"  = "application/xml"
                    "Accept"        = "application/xml"
                } -Body $bodyHost).Content)

        $ProgressPreference = $origProgressPreference

        # Throw error if no hosts are returned
        if ($null -eq $responseHostAdd.ServiceResponse.data.HostAsset) {
            return $null
        }

        foreach ($asset in $responseHostAdd.ServiceResponse.data.HostAsset) {
            $assets.Add( # Create new QualysAsset and add connection info before adding to $assets list
                ([QualysAsset]::new($asset) | Add-Member -MemberType NoteProperty -Name "username" -Value $inputUsername -Force -PassThru | Add-Member -MemberType NoteProperty -Name "keyvault" -Value $inputKeyvault -Force -PassThru | Add-Member -MemberType NoteProperty -Name "qualysApiUrl" -Value $inputQualysApiUrl -Force -PassThru | Add-Member -MemberType NoteProperty -Name "secretName" -Value $inputSecretName -Force -PassThru)
                )
        }

        $lastId = $responseHostAdd.ServiceResponse.lastId
    }
    #endregion full pull of all hosts

    return $assets
}
