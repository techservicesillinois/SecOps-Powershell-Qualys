---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# QualysAsset Class

techservicesillinois.UofIQualys.QualysAsset

## Description

The QualysAsset class contains properties provided by the Qualys QPS API.

In addition to these, user-assigned properties are also available:

- qualysApiUrl: The URL of the Qualys API endpoint to use, ending at the hostname. Assigned automatically with Get-QualysAsset.

- prefix: A tag name prefix which may be used for the Sync-QualysTagAssignment function.

- vtags: A PSCustomObject with pairs of TagName and Category values. These may be obtained from tag assignments in VMWare, Azure, AWS, etc.

## Methods

### ToString()

Returns the Qualys asset's name.

### ToJson()

Returns the Qualys asset and properties in JSON format.

### AssignTag($QualysTag, $inputCredential)

Assigns a Qualys tag object to the asset using the given credentials.

### UnassignTag($QualysTag, $inputCredential)

Unassigns a Qualys tag object from the asset using the given credentials.

### AssignTags($QualysTags, $inputCredential)

Assigns a list of Qualys tag objects to the asset using the given credentials.

### UnassignTags($QualysTags, $inputCredential)

Unassigns a list of Qualys tag objects from the asset using the given credentials.

### AssignTagByName($tagName, $inputCredential)

Assigns a Qualys tag object to the asset using the tag's name and the given credentials.

### UnassignTagByName($tagName, $inputCredential)

Unassigns a Qualys tag object to the asset using the tag's name and the given credentials.

### AssignTagsByName($tagNames, $inputCredential)

Assigns a list of Qualys tag objects to the asset using the tag names and the given credentials.

### UnassignTagsByName($tagNames, $inputCredential)

Unassigns a list of Qualys tag objects to the asset using the tag names and the given credentials.

### AssignTagById ($tagId, $inputCredential)

Assigns a Qualys tag object to the asset using the tag's ID and the given credentials.

### UnassignTagById($tagName, $inputCredential)

Unassigns a Qualys tag object to the asset using the tag's ID and the given credentials.

### AssignTagsById($tagNames, $inputCredential)

Assigns a list of Qualys tag objects to the asset using the tag IDs and the given credentials.

### UnassignTagsById($tagNames, $inputCredential)

Unassigns a list of Qualys tag objects to the asset using the tag IDs and the given credentials.

## Properties

### 1st Level Properties

| Property | Type |
| --- | --- |
| `account` | PSCustomObject[] |
| `address` | string |
| `biosDescription` | string |
| `created` | datetime |
| `criticalityScore` | string |
| `dnsHostName` | string |
| `fqdn` | string |
| `id` | Int32 |
| `informationGatheredUpdated` | datetime |
| `isDockerHost` | System.Boolean |
| `lastComplianceScan` | datetime |
| `lastLoggedOnUser` | string |
| `lastSystemBoot` | datetime |
| `lastVulnScan` | datetime |
| `manufacturer` | string |
| `model` | string |
| `modified` | datetime |
| `name` | string |
| `networkGuid` | guid |
| `os` | string |
| `qwebHostId` | int32 |
| `timezone` | string |
| `totalMemory` | int32 |
| `trackingMethod` | string |
| `type` | string |
| `vulnsUpdated` | datetime |
| `agentInfo` | PSCustomObject |
| `networkInterface` | PSCustomObject[] |
| `openPort` | PSCustomObject[] |
| `processor` | PSCustomObject[] |
| `software` | PSCustomObject[] |
| `tags` | PSCustomObject[] |
| `volume` | PSCustomObject[] |
| `vuln` | PSCustomObject[] |
| `qualysApiUrl` | string |
| `prefix` | string |
| `vtags` | PSCustomObject[] |

### Properties with nested properties

| Property | Type | Subproperty | Subtype | Subsubproperty | Subsubtype |
| --- | --- | --- | --- | --- | --- |
| `account` | PSCustomObject[] | `username` | string | | |
| `agentInfo` | PSCustomObject | `agentId` | Guid | | |
|  |  | `agentVersion` | Version | | |
|  |  | `lastCheckedIn` | datetime | | |
|  |  | `status` | string | | |
|  |  | `connectedFrom` | ipaddress | | |
|  |  | `location` | string | | |
|  |  | `locationGeoLatitude` | double | | |
|  |  | `locationGeoLongitude` | double | | |
|  |  | `chirpStatus` | string | | |
|  |  | `platform` | string | | |
|  |  | `activatedModule` | string[] | | |
|  |  | `manifestVersion` | PSCustomObject | `vm` | string |
|  |  |  |  | `sca` | string |
|  |  | `agentConfiguration` | PSCustomObject | `id` | int32 |
|  |  |  |  | `name` | string |
|  |  | `activationKey` | PSCustomObject | `activationId` | Guid |
|  |  |  |  | `title` | string |
| `networkInterface` | PSCustomObject[] | `interfaceName` | string | | |
|  |  | `macAddress` | string | | |
|  |  | `address` | IPAddress | | |
|  |  | `gatewayAddress` | string | | |
|  |  | `hostname` | string | | |
| `openPort` | PSCustomObject[] | `port` | int32 | | |
|  |  | `protocol` | string | | |
| `processor` | PSCustomObject[] | `name` | string | | |
|  |  | `speed` | int32 | | |
| `software` | PSCustomObject[] | `name` | string | | |
|  |  | `version` | string | | |
| `tags` | PSCustomObject[] | `id` | int32 | | |
|  |  | `name` | string | | |
| `volume` | PSCustomObject[] | `name` | string | | |
|  |  | `size` | int64 | | |
|  |  | `free` | int64 | | |
| `vuln` | PSCustomObject[] | `qid` | int32 | | |
|  |  | `hostInstanceVulnId` | int32 | | |
|  |  | `firstFound` | datetime | | |
|  |  | `lastFound` | datetime | | |
