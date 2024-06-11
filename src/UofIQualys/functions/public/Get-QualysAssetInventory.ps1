function Get-QualysAssetInventory {
    <#
        .SYNOPSIS
            Gets the Qualys asset inventory.
        .DESCRIPTION
            This function retrieves the Qualys asset inventory. Batch size maximum defaults to 1000.
            By default, this returns an array of QualysAsset objects. By default, it returns all objects visible to the service account.
        .PARAMETER Credential
            The credential object to log into Qualys.
        .PARAMETER batchSize
            The number of assets to retrieve in each batch. Default is 1000.
        .EXAMPLE
            $qInventory = Get-QualysAssetInventory -Credential (Get-Credential) -batchSize 500
    #>

    param (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential,

        [int32]
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

        $RestSplat = @{
            RelativeURI = 'qps/rest/2.0/search/am/hostasset'
            Method      = 'POST'
            XmlBody     = $bodyHost
            Credential  = $Credential
        }

        $responseHostAdd = [xml](Invoke-QualysRestCall @RestSplat)

        $ProgressPreference = $origProgressPreference

        # Throw error if no hosts are returned
        if ($null -eq $responseHostAdd.ServiceResponse.data.HostAsset) {
            return $null
        }

        foreach ($asset in $responseHostAdd.ServiceResponse.data.HostAsset) {
            $assets.Add( # Create new QualysAsset and add connection info before adding to $assets list
                ([QualysAsset]::new($asset))
            )
        }

        $lastId = $responseHostAdd.ServiceResponse.lastId
    }
    #endregion full pull of all hosts

    return $assets
}
