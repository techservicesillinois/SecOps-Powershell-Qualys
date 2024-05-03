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
    [string] $account
    [string] $address
    [string] $biosDescription
    [string] $created
    [string] $criticalityScore
    [string] $dnsHostName
    [string] $fqdn
    [string] $id
    [string] $informationGatheredUpdated
    [string] $isDockerHost
    [string] $lastComplianceScan
    [string] $lastLoggedOnUser
    [string] $lastSystemBoot
    [string] $lastVulnScan
    [string] $manufacturer
    [string] $model
    [string] $modified
    [string] $name
    [string] $networkGuid
    [string] $os
    [string] $qwebHostId
    [string] $timezone
    [string] $totalMemory
    [string] $trackingMethod
    [string] $type
    [string] $vulnsUpdated
    [System.Xml.XmlElement] $agentInfo
    [System.Xml.XmlElement] $networkInterface
    [System.Xml.XmlElement] $openPort
    [System.Xml.XmlElement] $processor
    [System.Xml.XmlElement] $software
    [System.Xml.XmlElement] $tags
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
        $this.tags = $QualysAssetApiResponse.tags
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

    [PSCustomObject] SyncTags(

        [PSCredential]
        $inputCredential = $credential

    ) {
        <#
        .SYNOPSIS
            Syncs tags on a Qualys asset.
        .DESCRIPTION
            This function syncs tags on a Qualys asset.
        .EXAMPLE
            $asset.SyncTags()
        .NOTES
            If this is done on an object created by Get-QualysAsset, you must add a $vtags property to the object. See readme for more information.
            A $prefix property may also be added to the object, if the tags are prefixed with a string.
            Authors:
            - Carter Kindley
        #>
        $responses = [PSCustomObject]@{
            Added    = New-Object 'System.Collections.ArrayList'
            Removed  = New-Object 'System.Collections.ArrayList'
            Existing = New-Object 'System.Collections.ArrayList'
            Issues   = New-Object 'System.Collections.ArrayList'
            Info     = New-Object 'System.Collections.ArrayList'
        }
        # Check $this.tags.list.TagSimple for incorrect tags, based on $vtags name
        foreach ( $tag in $this.vtags) {
            switch ($tag.Category) {
                "Data Security" {
                    # If security level is incorrect, remove and add correct tag
                    if ($tag.TagName -ne "Medium Security" -and $this.tags.list.TagSimple.Name -contains "$($this.Prefix)Medium Security") {
                        $response = Remove-QualysTagAssignment -assetId $this.id -tagId ($this.tags.list.TagSimple | Where-Object -Property 'name' -EQ "$($this.Prefix)Medium Security").id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Removed.Add("$($this.Prefix)Medium Security") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    elseif ($tag.TagName -ne "High Security" -and $this.tags.list.TagSimple.Name -contains "$($this.Prefix)High Security") {
                        $response = Remove-QualysTagAssignment -assetId $this.id -tagId ($this.tags.list.TagSimple | Where-Object -Property 'name' -EQ "$($this.Prefix)High Security").id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Removed.Add("$($this.Prefix)High Security") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    elseif ($tag.TagName -ne "Low Security" -and $this.tags.list.TagSimple.Name -contains "$($this.Prefix)Low Security") {
                        $response = Remove-QualysTagAssignment -assetId $this.id -tagId ($this.tags.list.TagSimple | Where-Object -Property 'name' -EQ "$($this.Prefix)Low Security").id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Removed.Add("$($this.Prefix)Low Security") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    # Add the correct tag if needed
                    if ($this.tags.list.TagSimple.Name -notcontains "$($this.Prefix)$($tag.TagName)") {
                        $response = Add-QualysTagAssignment -assetId $this.id -tagId (Get-QualysTag -tagName "$($this.Prefix)$($tag.TagName)" -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl).id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Added.Add("$($this.Prefix)$($tag.TagName)") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    else {
                        $responses.Existing.Add("$($this.Prefix)$($tag.TagName)") | Out-Null
                    }
                }
                "Data Classification" {
                    # Public, Private Restricted, or Private, Highly-Restricted
                    if ($tag.TagName -ne "Public" -and $this.tags.list.TagSimple.Name -contains "$($this.Prefix)Public") {
                        $response = Remove-QualysTagAssignment -assetId $this.id -tagId ($this.tags.list.TagSimple | Where-Object -Property 'name' -EQ "$($this.Prefix)Public").id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Removed.Add("$($this.Prefix)Public") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    elseif ($tag.TagName -ne "Private Restricted" -and $this.tags.list.TagSimple.Name -contains "$($this.Prefix)Private Restricted") {
                        $response = Remove-QualysTagAssignment -assetId $this.id -tagId ($this.tags.list.TagSimple | Where-Object -Property 'name' -EQ "$($this.Prefix)Private Restricted").id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Removed.Add("$($this.Prefix)Private Restricted") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    elseif ($tag.TagName -ne "Private, Highly-Restricted" -and $this.tags.list.TagSimple.Name -contains "$($this.Prefix)Private, Highly-Restricted") {
                        $response = Remove-QualysTagAssignment -assetId $this.id -tagId ($this.tags.list.TagSimple | Where-Object -Property 'name' -EQ "$($this.Prefix)Private, Highly-Restricted").id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Removed.Add("$($this.Prefix)Private, Highly-Restricted") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    # Add the correct tag if needed
                    if ($this.tags.list.TagSimple.Name -notcontains "$($this.Prefix)$($tag.TagName)") {
                        $response = Add-QualysTagAssignment -assetId $this.id -tagId (Get-QualysTag -tagName "$($this.Prefix)$($tag.TagName)" -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl).id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Added.Add("$($this.Prefix)$($tag.TagName)") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    else {
                        $responses.Existing.Add("$($this.Prefix)$($tag.TagName)") | Out-Null
                    }
                }
                "Department" {
                    # If a tag that looks like a department is incorrect, remove and add correct tag. The Where-Object pipe should match something like a CESI unit, which will be $this.Prefix + 3-5 capital letters
                    # We should do better matching here, and ensuring only one object is returned. If we're sure we only match departmental tags, we can loop through and remove all incorrect tags?
                    $deptTags = $this.tags.list.TagSimple | Where-Object -Property 'name' -CMatch "^$($this.Prefix)[A-Z]{2,5}$"
                    foreach ($deptTag in $deptTags) {
                        if ("$($this.Prefix)$($tag.TagName)" -ne $deptTag.Name) {
                            $response = Remove-QualysTagAssignment -assetId $this.id -tagId $deptTag.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                            if ($null -eq $response) {
                                $responses.Removed.Add($deptTag.Name) | Out-Null
                            }
                            else {
                                $responses.Issues.Add($response) | Out-Null
                            }
                        }
                    }
                    # Add the correct tag if needed
                    if ($this.tags.list.TagSimple.Name -notcontains "$($this.Prefix)$($tag.TagName)") {
                        $response = Add-QualysTagAssignment -assetId $this.id -tagId (Get-QualysTag -tagName "$($this.Prefix)$($tag.TagName)" -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl).id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Added.Add("$($this.Prefix)$($tag.TagName)") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    else {
                        $responses.Existing.Add("$($this.Prefix)$($tag.TagName)") | Out-Null
                    }
                }
                "Environment" {
                    # If environment is incorrect, remove and add correct tag
                    if ($tag.TagName -ne "Production" -and $this.tags.list.TagSimple.Name -contains "$($this.Prefix)Production Environment") {
                        $response = Remove-QualysTagAssignment -assetId $this.id -tagId ($this.tags.list.TagSimple | Where-Object -Property 'name' -EQ "$($this.Prefix)Production Environment").id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Removed.Add("$($this.Prefix)Production Environment") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    elseif ($tag.TagName -ne "Development" -and $this.tags.list.TagSimple.Name -contains "$($this.Prefix)Development Environment") {
                        $response = Remove-QualysTagAssignment -assetId $this.id -tagId ($this.tags.list.TagSimple | Where-Object -Property 'name' -EQ "$($this.Prefix)Development Environment").id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Removed.Add("$($this.Prefix)Development Environment") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    elseif ($tag.TagName -ne "Test" -and $this.tags.list.TagSimple.Name -contains "$($this.Prefix)Test Environment") {
                        $response = Remove-QualysTagAssignment -assetId $this.id -tagId ($this.tags.list.TagSimple | Where-Object -Property 'name' -EQ "$($this.Prefix)Test Environment").id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Removed.Add("$($this.Prefix)Test Environment") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    # Add the correct tag if needed
                    if ($this.tags.list.TagSimple.Name -notcontains "$($this.Prefix)$($tag.TagName) Environment") {
                        $response = Add-QualysTagAssignment -assetId $this.id -tagId (Get-QualysTag -tagName "$($this.Prefix)$($tag.TagName) Environment" -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl).id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
                        if ($null -eq $response) {
                            $responses.Added.Add("$($this.Prefix)$($tag.TagName) Environment") | Out-Null
                        }
                        else {
                            $responses.Issues.Add($response) | Out-Null
                        }
                    }
                    else {
                        $responses.Existing.Add("$($this.Prefix)$($tag.TagName) Environment") | Out-Null
                    }
                }
                default {
                    # If the tag category is not recognized, add it to the info list
                    $responses.Info.Add($tag.Category) | Out-Null
                }
            }
        }

        return $responses
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

        [string]
        $tagId,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Assign a tag to this asset by ID
        Add-QualysTagAssignment -assetId $this.id -tagId $tagId -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] UnassignTagById (

        [string]
        $tagId,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Unassign a tag from this asset by ID
        Remove-QualysTagAssignment -assetId $this.id -tagId $tagId -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] AssignTagsById (

        [string[]]
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

        [string[]]
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
    [string] $id
    [string] $modified
    [string] $name
    [string] $parentTagId

    # User-provided properties
    [string] $qualysApiUrl
    [QualysTag] $parentTag

    # Constructor
    QualysTag ( [System.Xml.XmlElement] $QualysTagApiResponse ) {
        $this.created = $QualysTagApiResponse.created
        $this.id = $QualysTagApiResponse.id
        $this.modified = $QualysTagApiResponse.modified
        $this.name = $QualysTagApiResponse.name
        $this.parentTagId = $QualysTagApiResponse.parentTagId
        $this.parentTag = $null
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

        [string]
        $assetId,

        [PSCredential]
        $inputCredential = $credential

    ) {
        # Assign this tag to a Qualys asset by ID
        Add-QualysTagAssignment -assetId $assetId -tagId $this.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl
    }

    [void] UnassignById (

        [string]
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

}
