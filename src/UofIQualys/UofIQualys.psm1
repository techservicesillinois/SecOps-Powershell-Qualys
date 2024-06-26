$Script:Settings = Get-Content -Path "$PSScriptRoot\settings.json" | ConvertFrom-Json

# This will override the settings.json file if required.
if ($env:QualysSettings) {
    $script:Settings= $env:QualysSettings | ConvertFrom-Json
}

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
    [Int64] $id
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
    [Int64] $qwebHostId
    [string] $timezone
    [Int64] $totalMemory
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
        $this.created = if ($QualysAssetApiResponse.created) { [datetime]$QualysAssetApiResponse.created } else { [datetime]'1970-01-01T00:00:00Z' }
        $this.criticalityScore = $QualysAssetApiResponse.criticalityScore
        $this.dnsHostName = $QualysAssetApiResponse.dnsHostName
        $this.fqdn = $QualysAssetApiResponse.fqdn
        $this.id = $QualysAssetApiResponse.id
        $this.informationGatheredUpdated = if ($QualysAssetApiResponse.informationGatheredUpdated) { [datetime]$QualysAssetApiResponse.informationGatheredUpdated } else { [datetime]'1970-01-01T00:00:00Z' }
        $this.isDockerHost = $QualysAssetApiResponse.isDockerHost
        $this.lastComplianceScan = if ($QualysAssetApiResponse.lastComplianceScan) { [datetime]$QualysAssetApiResponse.lastComplianceScan } else { [datetime]'1970-01-01T00:00:00Z' }
        $this.lastLoggedOnUser = $QualysAssetApiResponse.lastLoggedOnUser
        $this.lastSystemBoot = if ($QualysAssetApiResponse.lastSystemBoot) { [datetime]$QualysAssetApiResponse.lastSystemBoot } else { [datetime]'1970-01-01T00:00:00Z' }
        $this.lastVulnScan = if ($QualysAssetApiResponse.lastVulnScan) { [datetime]$QualysAssetApiResponse.lastVulnScan } else { [datetime]'1970-01-01T00:00:00Z' }
        $this.manufacturer = $QualysAssetApiResponse.manufacturer
        $this.model = $QualysAssetApiResponse.model
        $this.modified = if ($QualysAssetApiResponse.modified) { [datetime]$QualysAssetApiResponse.modified } else { [datetime]'1970-01-01T00:00:00Z' }
        $this.name = $QualysAssetApiResponse.name
        $this.networkGuid = if ($QualysAssetApiResponse.networkGuid) { [guid]$QualysAssetApiResponse.networkGuid } else { [guid]'00000000-0000-0000-0000-000000000000' }
        $this.os = $QualysAssetApiResponse.os
        $this.qwebHostId = $QualysAssetApiResponse.qwebHostId
        $this.timezone = $QualysAssetApiResponse.timezone
        $this.totalMemory = $QualysAssetApiResponse.totalMemory
        $this.trackingMethod = $QualysAssetApiResponse.trackingMethod
        $this.type = $QualysAssetApiResponse.type
        $this.vulnsUpdated = if ($QualysAssetApiResponse.vulnsUpdated) { [datetime]$QualysAssetApiResponse.vulnsUpdated } else { [datetime]'1970-01-01T00:00:00Z' }
        $this.agentInfo = if ($QualysAssetApiResponse.agentInfo) {
            New-Object PSCustomObject -Property @{
                agentId              = if ($QualysAssetApiResponse.agentInfo.agentId) { [Guid]$QualysAssetApiResponse.agentInfo.agentId } else { [Guid]'00000000-0000-0000-0000-000000000000' }
                agentVersion         = [Version]$QualysAssetApiResponse.agentInfo.agentVersion
                lastCheckedIn        = if ($QualysAssetApiResponse.agentInfo.lastCheckedIn) { [datetime]$QualysAssetApiResponse.agentInfo.lastCheckedIn } else { [datetime]'1970-01-01T00:00:00Z' }
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
                    id   = [Int64]$QualysAssetApiResponse.agentInfo.agentConfiguration.id
                    name = [string]$QualysAssetApiResponse.agentInfo.agentConfiguration.name
                }
                activationKey        = New-Object PSCustomObject -Property @{
                    activationId = if ($QualysAssetApiResponse.agentInfo.activationKey.activationId) { [Guid]$QualysAssetApiResponse.agentInfo.activationKey.activationId } else { [Guid]'00000000-0000-0000-0000-000000000000' }
                    title        = [string]$QualysAssetApiResponse.agentInfo.activationKey.title
                }
            }
        }
        else { $null }
        $this.networkInterface = if ($QualysAssetApiResponse.networkInterface.list.HostAssetInterface) {$QualysAssetApiResponse.networkInterface.list.HostAssetInterface | ForEach-Object {
            New-Object PSCustomObject -Property @{
                interfaceName  = [string]$_.name
                macAddress     = [string]$_.mac
                address        = [IPAddress]$_.ip
                gatewayAddress = [string]$_.gateway
                hostname       = [string]$_.hostname
            }
        }
    }
        else { $null }

        $this.openPort = $QualysAssetApiResponse.openPort.list.HostAssetOpenPort | ForEach-Object {
            New-Object PSCustomObject -Property @{
                port     = [Int64]$_.port
                protocol = [string]$_.protocol
            }
        }
        $this.processor = if($QualysAssetApiResponse.processor.list.HostAssetProcessor) { $QualysAssetApiResponse.processor.list.HostAssetProcessor | ForEach-Object {
            New-Object PSCustomObject -Property @{
                name  = [string]$_.name
                speed = [Int64]$_.speed
            }
        }
    }
        else { $null }
        $this.software = if ($QualysAssetApiResponse.software.list.HostAssetSoftware) {$QualysAssetApiResponse.software.list.HostAssetSoftware | ForEach-Object {
            New-Object PSCustomObject -Property @{
                name    = [string]$_.name
                version = [string]$_.version
            }
        }
    }
        else { $null }
        $this.tags = if ($QualysAssetApiResponse.tags.list.TagSimple) {$QualysAssetApiResponse.tags.list.TagSimple | ForEach-Object {
            New-Object PSCustomObject -Property @{
                id   = [Int64]$_.id
                name = [string]$_.name
            }
        }
    }
        else { $null }
        $this.volume = if ($QualysAssetApiResponse.volume.list.HostAssetVolume) {$QualysAssetApiResponse.volume.list.HostAssetVolume | ForEach-Object {
            New-Object PSCustomObject -Property @{
                name = [string]$_.name
                size = [int64]$_.size
                free = [int64]$_.free
            }
        }
    }
        else { $null }
        $this.vuln = if ($QualysAssetApiResponse.vuln.list.HostAssetVuln) {$QualysAssetApiResponse.vuln.list.HostAssetVuln | ForEach-Object {
            New-Object PSCustomObject -Property @{
                qid                = [Int64]$_.qid
                hostInstanceVulnId = [Int64]$_.hostInstanceVulnId
                firstFound         = if ($_.firstFound) { [datetime]$_.firstFound } else { [datetime]'1970-01-01T00:00:00Z' }
                lastFound          = if ($_.lastFound) { [datetime]$_.lastFound } else { [datetime]'1970-01-01T00:00:00Z' }
            }
        }
    }
        else { $null }
    }

    # Methods
    [string] ToString() {
        return "$($this.name)"
    }

    [string] ToJson() {
        return $($this  | ConvertTo-Json)
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
    [Int64] $id
    [datetime] $modified
    [string] $name
    [Int64] $parentTagId

    # User-provided properties
    [QualysTag] $parentTag
    [System.Collections.Generic.List[QualysTag]] $childTags

    # Constructor
    QualysTag ( [System.Xml.XmlElement] $QualysTagApiResponse ) {
        $this.created = $QualysTagApiResponse.created
        $this.id = $QualysTagApiResponse.id
        # Set modified to Jan 1, 1970 if it is null
        $this.modified = if ($QualysTagApiResponse.modified) { $QualysTagApiResponse.modified } else { [datetime]'1970-01-01T00:00:00Z' }
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
}
