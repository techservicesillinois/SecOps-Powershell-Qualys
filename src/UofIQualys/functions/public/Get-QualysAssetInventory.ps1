function Get-QualysAssetInventory {
    <#
        .SYNOPSIS
            Gets the Qualys asset inventory.
        .DESCRIPTION
            This function retrieves the Qualys asset inventory. Batch size maximum defaults to 1000.
            By default, this returns an array of QualysAsset objects. By default, it returns all objects visible to the service account.
        .PARAMETER Credential
            The credential object to log into Qualys.
        .PARAMETER BatchSize
            The number of assets to retrieve in each batch. Default is 1000.
        .EXAMPLE
            $qInventory = Get-QualysAssetInventory -Credential (Get-Credential) -batchSize 500
    #>

    param (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential,

        [int32]
        $BatchSize = 1000
    )

    # Region full pull of all hosts

    $Assets = New-Object System.Collections.Generic.List[QualysAsset]
    $LastId = 0

    while ($null -ne $LastId) {
        $BodyHost = "<ServiceRequest>
                        <preferences>
                            <limitResults>$BatchSize</limitResults>
                        </preferences>
                        <filters>
                            <Criteria field=""id"" operator=""GREATER"">$LastId</Criteria>
                        </filters>
                    </ServiceRequest>"

        $OrigProgressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'

        $RestSplat = @{
            RelativeURI = 'qps/rest/2.0/search/am/hostasset'
            Method      = 'POST'
            XmlBody     = $BodyHost
            Credential  = $Credential
        }

        $ResponseHostAdd = [xml](Invoke-QualysTagRestCall @RestSplat)

        $ProgressPreference = $OrigProgressPreference

        # Throw error if no hosts are returned
        if ($null -eq $ResponseHostAdd.ServiceResponse.data.HostAsset) {
            return $null
        }

        foreach ($Asset in $ResponseHostAdd.ServiceResponse.data.HostAsset) {
            $Assets.Add( # Create new QualysAsset and add connection info before adding to $assets list
                ([QualysAsset]::new($asset))
            )
        }

        $LastId = $ResponseHostAdd.ServiceResponse.lastId
    }
    #endregion full pull of all hosts

    return $Assets
}
