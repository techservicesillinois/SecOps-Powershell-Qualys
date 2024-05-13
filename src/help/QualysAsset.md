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



## Properties

| Property Name | Property Type |
| --- | --- |
| account | string |
| address | string |
| biosDescription | string |
| created | string |
| criticalityScore | string |
| dnsHostName | string |
| fqdn | string |
| id | string |
| informationGatheredUpdated | string |
| isDockerHost | string |
| lastComplianceScan | string |
| lastLoggedOnUser | string |
| lastSystemBoot | string |
| lastVulnScan | string |
| manufacturer | string |
| model | string |
| modified | string |
| name | string |
| networkGuid | string |
| os | string |
| qwebHostId | string |
| timezone | string |
| totalMemory | string |
| trackingMethod | string |
| type | string |
| vulnsUpdated | string |
| agentInfo | System.Xml.XmlElement |
| networkInterface | System.Xml.XmlElement |
| openPort | System.Xml.XmlElement |
| processor | System.Xml.XmlElement |
| software | System.Xml.XmlElement |
| tags | System.Xml.XmlElement |
| volume | System.Xml.XmlElement |
| vuln | System.Xml.XmlElement |
| qualysApiUrl | string |
| prefix | string |
| vtags | PSCustomObject |
