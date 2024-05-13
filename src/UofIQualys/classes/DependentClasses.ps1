class QualysAsset {
    <#
    .SYNOPSIS
        A class representing a Qualys asset.
    .DESCRIPTION
        This class represents a Qualys asset.
    .EXAMPLE
        $asset = Get-QualysAsset -assetName "Server1"

        # Get tags from vSphere
            $vmwareTags = ($vm | Get-TagAssignment).Tag

            # Create PSCustomObject with tag name and category
            $vtags = foreach ($tag in $vmwareTags) {
                [PSCustomObject]@{
                    TagName  = $tag.Name.ToString()
                    Category = $tag.Category.ToString()
                }
            }

        # Get tags from Azure
            $azureTags = (Get-AzVm -Name "Server1").Tags

            # Create PSCustomObject with tag name and category
            $vtags = foreach ($tag in $azureTags.GetEnumerator()) {
                [PSCustomObject]@{
                    TagName  = $tag.Value
                    Category = $tag.Key
                }
            }

            # Add tags to the asset
            $asset.vtags += $vtags

        # Sync tags on the asset
        $asset.SyncTags()


    .NOTES
        Authors:
        - Carter Kindley

    #>

    # Properties from Qualys QPS API
    [System.Xml.XmlElement] $account
    [string] $address
    [string] $biosDescription
    [datetime] $created
    [string] $criticalityScore
    [string] $dnsHostName
    [string] $fqdn
    [Int32] $id
    [datetime] $informationGatheredUpdated
    [System.Boolean] $isDockerHost
    [datetime] $lastComplianceScan
    [string] $lastLoggedOnUser
    [datetime] $lastSystemBoot
    [datetime] $lastVulnScan
    [string] $manufacturer
    [string] $model
    [datetime] $modified
    [string] $name
    [guid] $networkGuid
    [string] $os
    [int32] $qwebHostId
    [string] $timezone
    [int32] $totalMemory
    [string] $trackingMethod
    [string] $type
    [datetime] $vulnsUpdated
    [System.Xml.XmlElement] $agentInfo
    [System.Xml.XmlElement] $networkInterface
    [System.Xml.XmlElement] $openPort
    [System.Xml.XmlElement] $processor
    [System.Xml.XmlElement] $software
    [PSCustomObject[]]$tags
    [System.Xml.XmlElement] $volume
    [System.Xml.XmlElement] $vuln

    # User-provided properties
    [string] $qualysApiUrl
    [string] $prefix
    [PSCustomObject] $vtags


    # Constructor
    QualysAsset ( [System.Xml.XmlElement] $QualysAssetApiResponse ) {
        $this.account = $QualysAssetApiResponse.account
        $this.address = $QualysAssetApiResponse.address
        $this.biosDescription = $QualysAssetApiResponse.biosDescription
        $this.created = $QualysAssetApiResponse.created
        $this.criticalityScore = $QualysAssetApiResponse.criticalityScore
        $this.dnsHostName = $QualysAssetApiResponse.dnsHostName
        $this.fqdn = $QualysAssetApiResponse.fqdn
        $this.id = $QualysAssetApiResponse.id
        $this.informationGatheredUpdated = $QualysAssetApiResponse.informationGatheredUpdated
        $this.isDockerHost = $QualysAssetApiResponse.isDockerHost
        $this.lastComplianceScan = $QualysAssetApiResponse.lastComplianceScan
        $this.lastLoggedOnUser = $QualysAssetApiResponse.lastLoggedOnUser
        $this.lastSystemBoot = $QualysAssetApiResponse.lastSystemBoot
        $this.lastVulnScan = $QualysAssetApiResponse.lastVulnScan
        $this.manufacturer = $QualysAssetApiResponse.manufacturer
        $this.model = $QualysAssetApiResponse.model
        $this.modified = $QualysAssetApiResponse.modified
        $this.name = $QualysAssetApiResponse.name
        $this.networkGuid = $QualysAssetApiResponse.networkGuid
        $this.os = $QualysAssetApiResponse.os
        $this.qwebHostId = $QualysAssetApiResponse.qwebHostId
        $this.timezone = $QualysAssetApiResponse.timezone
        $this.totalMemory = $QualysAssetApiResponse.totalMemory
        $this.trackingMethod = $QualysAssetApiResponse.trackingMethod
        $this.type = $QualysAssetApiResponse.type
        $this.vulnsUpdated = $QualysAssetApiResponse.vulnsUpdated
        $this.agentInfo = $QualysAssetApiResponse.agentInfo
        $this.networkInterface = $QualysAssetApiResponse.networkInterface
        $this.openPort = $QualysAssetApiResponse.openPort
        $this.processor = $QualysAssetApiResponse.processor
        $this.software = $QualysAssetApiResponse.software
        $this.tags = $QualysAssetApiResponse.tags.list.TagSimple | ForEach-Object {
            New-Object PSCustomObject -Property @{
                id   = $_.id
                name = $_.name
            }
        }
        $this.volume = $QualysAssetApiResponse.volume
        $this.vuln = $QualysAssetApiResponse.vuln
    }

    # Methods
    [string] ToString() {
        return "$($this.name)"
    }

    [string] ToJson() {
        return @"
        "account": "$($this.account)",
        "address": "$($this.address)",
        "biosDescription": "$($this.biosDescription)",
        "created": "$($this.created)",
        "criticalityScore": "$($this.criticalityScore)",
        "dnsHostName": "$($this.dnsHostName)",
        "fqdn": "$($this.fqdn)",
        "id": "$($this.id)",
        "informationGatheredUpdated": "$($this.informationGatheredUpdated)",
        "isDockerHost": "$($this.isDockerHost)",
        "lastComplianceScan": "$($this.lastComplianceScan)",
        "lastLoggedOnUser": "$($this.lastLoggedOnUser)",
        "lastSystemBoot": "$($this.lastSystemBoot)",
        "lastVulnScan": "$($this.lastVulnScan)",
        "manufacturer": "$($this.manufacturer)",
        "model": "$($this.model)",
        "modified": "$($this.modified)",
        "name": "$($this.name)",
        "networkGuid": "$($this.networkGuid)",
        "os": "$($this.os)",
        "qwebHostId": "$($this.qwebHostId)",
        "timezone": "$($this.timezone)",
        "totalMemory": "$($this.totalMemory)",
        "trackingMethod": "$($this.trackingMethod)",
        "type": "$($this.type)",
        "vulnsUpdated": "$($this.vulnsUpdated)",
        "agentInfo": "$($this.agentInfo)",
        "networkInterface": "$($this.networkInterface)",
        "openPort": "$($this.openPort)",
        "processor": "$($this.processor)",
        "software": "$($this.software)",
        "tags": "$($this.tags)",
        "volume": "$($this.volume)",
        "vuln": "$($this.vuln)"
        "username": "$($this.username)",
        "keyvault": "$($this.keyvault)",
        "secretName": "$($this.secretName)",
        "qualysApiUrl": "$($this.qualysApiUrl)"
"@
    }

    [void] AssignTag (

        [QualysTag]
        $QualysTag,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Assign a tag to this asset
        Add-QualysTagAssignment -assetId $this.id -tagId $QualysTag.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] UnassignTag (

        [QualysTag]
        $QualysTag,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Unassign a tag from this asset
        Remove-QualysTagAssignment -assetId $this.id -tagId $QualysTag.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] AssignTags (

        [QualysTag[]]
        $QualysTags,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Assign multiple tags to this asset
        foreach ($tag in $QualysTags) {
            Add-QualysTagAssignment -assetId $this.id -tagId $tag.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
        }
    }

    [void] UnassignTags (

        [QualysTag[]]
        $QualysTags,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Unassign multiple tags from this asset
        foreach ($tag in $QualysTags) {
            Remove-QualysTagAssignment -assetId $this.id -tagId $tag.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
        }
    }

    [void] AssignTagByName (

        [string]
        $tagName,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Assign a tag to this asset by name
        Add-QualysTagAssignment -assetId $this.id -tagId (Get-QualysTag -tagName $tagName -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl).id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] UnassignTagByName (

        [string]
        $tagName,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Unassign a tag from this asset by name
        Remove-QualysTagAssignment -assetId $this.id -tagId (Get-QualysTag -tagName $tagName -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl).id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] AssignTagsByName (

        [string[]]
        $tagNames,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Assign multiple tags to this asset by name
        foreach ($tagName in $tagNames) {
            Add-QualysTagAssignment -assetId $this.id -tagId (Get-QualysTag -tagName $tagName -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl).id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
        }
    }

    [void] UnassignTagsByName (

        [string[]]
        $tagNames,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Unassign multiple tags from this asset by name
        foreach ($tagName in $tagNames) {
            Remove-QualysTagAssignment -assetId $this.id -tagId (Get-QualysTag -tagName $tagName -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl).id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
        }
    }

    [void] AssignTagById (

        [Int32]
        $tagId,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Assign a tag to this asset by ID
        Add-QualysTagAssignment -assetId $this.id -tagId $tagId -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] UnassignTagById (

        [Int32]
        $tagId,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Unassign a tag from this asset by ID
        Remove-QualysTagAssignment -assetId $this.id -tagId $tagId -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] AssignTagsById (

        [Int32[]]
        $tagIds,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Assign multiple tags to this asset by ID
        foreach ($tagId in $tagIds) {
            Add-QualysTagAssignment -assetId $this.id -tagId $tagId -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
        }
    }

    [void] UnassignTagsById (

        [Int32[]]
        $tagIds,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Unassign multiple tags from this asset by ID
        foreach ($tagId in $tagIds) {
            Remove-QualysTagAssignment -assetId $this.id -tagId $tagId -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
        }
    }
}

class QualysTag {
    <#
    .SYNOPSIS
        A class representing a Qualys tag.
    .DESCRIPTION
        This class represents a Qualys tag.
    .EXAMPLE
        $tag = Get-QualysTag -tagName "Managed Linux"
    .NOTES
        Authors:
        - Carter Kindley

#>

    # Properties from Qualys QPS API
    [string] $created
    [Int32] $id
    [string] $modified
    [string] $name
    [Int32] $parentTagId

    # User-provided properties
    [string] $qualysApiUrl
    [QualysTag] $parentTag
    [System.Collections.Generic.List[QualysTag]] $childTags

    # Constructor
    QualysTag ( [System.Xml.XmlElement] $QualysTagApiResponse ) {
        $this.created = $QualysTagApiResponse.created
        $this.id = $QualysTagApiResponse.id
        $this.modified = $QualysTagApiResponse.modified
        $this.name = $QualysTagApiResponse.name
        $this.parentTagId = $QualysTagApiResponse.parentTagId
        $this.parentTag = $null
        $this.childTags = New-Object System.Collections.Generic.List[QualysTag]
    }

    # Methods
    [string] ToString() {
        return "QualysTag: $($this.name)"
    }

    [string] ToJson() {
        return @"
        "created": "$($this.created)",
        "id": "$($this.id)",
        "modified": "$($this.modified)",
        "name": "$($this.name)",
        "parentTagId": "$($this.parentTagId)"
"@
    }

    [void] Assign (

        [QualysAsset]
        $QualysAsset,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Assign this tag to a Qualys asset
        Add-QualysTagAssignment -assetId $QualysAsset.id -tagId $this.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] Unassign (

        [QualysAsset]
        $QualysAsset,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Unassign this tag from a Qualys asset
        Remove-QualysTagAssignment -assetId $QualysAsset.id -tagId $this.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] AssignById (

        [Int32]
        $assetId,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Assign this tag to a Qualys asset by ID
        Add-QualysTagAssignment -assetId $assetId -tagId $this.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] UnassignById (

        [Int32]
        $assetId,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Unassign this tag from a Qualys asset by ID
        Remove-QualysTagAssignment -assetId $assetId -tagId $this.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] AssignByName (

        [string]
        $assetName,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Assign this tag to a Qualys asset by name
        Add-QualysTagAssignment -assetId (Get-QualysAsset -assetName $assetName -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl).id -tagId $this.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] UnassignByName (

        [string]
        $assetName,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Unassign this tag from a Qualys asset by name
        Remove-QualysTagAssignment -assetId (Get-QualysAsset -assetName $assetName -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl).id -tagId $this.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    # Method to pull parent tag
    [void] GetParentTag (

        [PSCredential]
        $inputCredential = $credential,

        [switch]
        $Recursive = $false

    ) {
        $this.parentTag = Get-QualysTag -tagId $this.parentTagId -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl if{$Recursive} (-Recursive)
    }

    # Method to pull child tags
    [void] GetChildTags (

        [PSCredential]
        $inputCredential = $credential,

        [switch]
        $Recursive = $false

    ) {
        $this.childTags = Get-QualysTag -parentTagId $this.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl if{$Recursive} (-Recursive)
    }

}
