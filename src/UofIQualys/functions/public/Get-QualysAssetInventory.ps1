function Get-QualysAssetInventory {
    <#
        .SYNOPSIS
            Gets the Qualys asset inventory.
        .DESCRIPTION
            This function retrieves the Qualys asset inventory. Batch size maximum defaults to 1000.
            By default, this returns an array of QualysAsset objects. By default, it returns all objects visible to the service account.
        .PARAMETER inputCredential
            The credential object to log into Qualys. By default, this is set to the global variable $Credential.
        .PARAMETER inputQualysApiUrl
            The URL of the Qualys API.
        .PARAMETER batchSize
            The number of assets to retrieve in each batch. Default is 1000.
        .EXAMPLE
            $qInventory = Get-QualysAssetInventory -inputCredential (Get-Credential) -inputQualysApiUrl "https://qualysapi.qg4.apps.qualys.com" -batchSize 500
        .NOTES
            Authors:
            - Carter Kindley
    #>

    param (
        [PSCredential]
        $inputCredential = $Credential,
        [string]
        $inputQualysApiUrl = $qualysApiUrl,
        [int32]
        $batchSize = 1000
    )

    # If any of the non-mandatory parameters are not provided, return error and state which ones are empty
    if ([string]::IsNullOrEmpty($inputQualysApiUrl) -or [string]::IsNullOrEmpty($inputCredential.UserName) -or [string]::IsNullOrEmpty($inputCredential.GetNetworkCredential().Password)) {
        throw "One or more of the following parameters are empty: InputCredential, InputQualysApiUrl.
        By default, these parameters are set to the values of the global variables: Credential, QualysApiUrl.
        Please ensure these global variables are set, or provide the inputs, and try again."
    }

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
                    "Authorization" = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($InputCredential.UserName)`:$($InputCredential.GetNetworkCredential().Password)")))"
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
                ([QualysAsset]::new($asset) | Add-Member -MemberType NoteProperty -Name "qualysApiUrl" -Value $inputQualysApiUrl -Force -PassThru )
            )
        }

        $lastId = $responseHostAdd.ServiceResponse.lastId
    }
    #endregion full pull of all hosts

    return $assets
}
