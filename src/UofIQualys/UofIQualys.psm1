$Script:Settings = Get-Content -Path "$PSScriptRoot\settings.json" | ConvertFrom-Json

$Script:Session = $NULL
[int]$Script:APICallCount = 0

[String]$FunctionPath = Join-Path -Path $PSScriptRoot -ChildPath 'Functions'
#All function files are executed while only public functions are exported to the shell.
Get-ChildItem -Path $FunctionPath -Filter "*.ps1" -Recurse | ForEach-Object -Process {
    Write-Verbose -Message "Importing $($_.BaseName)"
    . $_.FullName | Out-Null
}

### Classes - most reliable to use when build in this root module file
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

                # Create PSCustomObject with tag name and catego    ry
            $vtags = foreach ($tag in $vmwareT    ags) {
                [PSCusto    mObject]@{
                    TagName  = $tag.N    ame.ToString()
                    Category = $tag.C    ategory.ToStrin    g()
                }
            }

            # Get tags from Azure
            $azureTags = (Ge    t-AzVm -Name "Server1").Tags

            # Create PSCusto    mObject with tag name and category
            $vtags = foreach     ($tag in $azureTags.GetEnumerato    r()) {
                [PSCustomObject    ]@{
                    TagName  = $    tag.Value
                            Category = $tag.Key
                    }
            }

            # Add tags to the asset
            $asset.vtags += $vtag
s

        # Sync tags on the asset
        $asset.SyncTags()


    .NOTES
        Authors:
        - Carter Kindley

    #>

    # Properties from Qualys QPS API
    [PSCustomObject[]] $account
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
    [PSCustomObject] $agentInfo
    [PSCustomObject[]] $networkInterface
    [PSCustomObject[]] $openPort
    [PSCustomObject[]] $processor
    [PSCustomObject[]] $software
    [PSCustomObject[]] $tags
    [PSCustomObject[]] $volume
    [PSCustomObject[]] $vuln

    # User-provided properties
    [string] $qualysApiUrl
    [string] $prefix
    [PSCustomObject[]] $vtags


    # Constructor
    QualysAsset ( [System.Xml.XmlElement] $QualysAssetApiResponse ) {
        $this.account = $QualysAssetApiResponse.account.list.HostAssetAccount | ForEach-Object {
            New-Object PSCustomObject -Property @{
                username = [string]$_.username
            }
        }
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
        $this.agentInfo = New-Object PSCustomObject -Property @{
            agentId              = [Guid]$QualysAssetApiResponse.agentInfo.agentId
            agentVersion         = [Version]$QualysAssetApiResponse.agentInfo.agentVersion
            lastCheckedIn        = [datetime]$QualysAssetApiResponse.agentInfo.lastCheckedIn
            status               = [string]$QualysAssetApiResponse.agentInfo.status
            connectedFrom        = [ipaddress]$QualysAssetApiResponse.agentInfo.connectedFrom
            location             = [string]$QualysAssetApiResponse.agentInfo.location
            locationGeoLatitude  = [double]$QualysAssetApiResponse.agentInfo.locationGeoLatitude
            locationGeoLongitude = [double]$QualysAssetApiResponse.agentInfo.locationGeoLongitude
            chirpStatus          = [string]$QualysAssetApiResponse.agentInfo.chirpStatus
            platform             = [string]$QualysAssetApiResponse.agentInfo.platform
            activatedModule      = [string[]]$QualysAssetApiResponse.agentInfo.activatedModule.Split(",")
            manifestVersion      = New-Object PSCustomObject -Property @{
                vm  = [String]$QualysAssetApiResponse.agentInfo.manifestVersion.vm
                sca = [String]$QualysAssetApiResponse.agentInfo.manifestVersion.sca
            }
            agentConfiguration   = New-Object PSCustomObject -Property @{
                id   = [int32]$QualysAssetApiResponse.agentInfo.agentConfiguration.id
                name = [string]$QualysAssetApiResponse.agentInfo.agentConfiguration.name
            }
            activationKey        = New-Object PSCustomObject -Property @{
                activationId = [Guid]$QualysAssetApiResponse.agentInfo.activationKey.activationId
                title        = [string]$QualysAssetApiResponse.agentInfo.activationKey.title
            }
        }
        $this.networkInterface = $QualysAssetApiResponse.networkInterface.list.HostAssetInterface | ForEach-Object {
            New-Object PSCustomObject -Property @{
                interfaceName  = [string]$_.name
                macAddress     = [string]$_.mac
                address        = [IPAddress]$_.ip
                gatewayAddress = [string]$_.gateway
                hostname       = [string]$_.hostname
            }
        }
        $this.openPort = $QualysAssetApiResponse.openPort.list.HostAssetOpenPort | ForEach-Object {
            New-Object PSCustomObject -Property @{
                port     = [int32]$_.port
                protocol = [string]$_.protocol
            }
        }
        $this.processor = $QualysAssetApiResponse.processor.list.HostAssetProcessor | ForEach-Object {
            New-Object PSCustomObject -Property @{
                name  = [string]$_.name
                speed = [int32]$_.speed
            }
        }
        $this.software = $QualysAssetApiResponse.software.list.HostAssetSoftware | ForEach-Object {
            New-Object PSCustomObject -Property @{
                name    = [string]$_.name
                version = [string]$_.version
            }
        }
        $this.tags = $QualysAssetApiResponse.tags.list.TagSimple | ForEach-Object {
            New-Object PSCustomObject -Property @{
                id   = [int32]$_.id
                name = [string]$_.name
            }
        }
        $this.volume = $QualysAssetApiResponse.volume.list.HostAssetVolume | ForEach-Object {
            New-Object PSCustomObject -Property @{
                name = [string]$_.name
                size = [int64]$_.size
                free = [int64]$_.free
            }
        }
        $this.vuln = $QualysAssetApiResponse.vuln.list.HostAssetVuln | ForEach-Object {
            New-Object PSCustomObject -Property @{
                qid                = [int32]$_.qid
                hostInstanceVulnId = [int32]$_.hostInstanceVulnId
                firstFound         = [datetime]$_.firstFound
                lastFound          = [datetime]$_.lastFound
            }
        }
    }

    # Methods
    [string] ToString() {
        return "$($this.name)"
    }

    [string] ToJson() {
        return $($this  | ConvertTo-Json)
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
    [datetime] $created
    [Int32] $id
    [datetime] $modified
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
        return "$($this.name)"
    }

    [string] ToJson() {
        return $($this | ConvertTo-Json)
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

        [switch]
        $Recursive = $false,

        [PSCredential]
        $inputCredential = $credential


    ) {
        $this.parentTag = Get-QualysTag -tagId $this.parentTagId -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl if { $Recursive } (-Recursive)
    }

    # Method to pull child tags
    [void] GetChildTags (

        [switch]
        $Recursive = $false,

        [PSCredential]
        $inputCredential = $credential

    ) {
        $this.childTags = Get-QualysTag -parentTagId $this.id -InputCredential $inputCredential -inputQualysApiUrl $this.QualysApiUrl if { $Recursive } (-Recursive)
    }

}
