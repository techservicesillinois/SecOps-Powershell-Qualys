---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# QualysTag Class

techservicesillinois.UofIQualys.QualysTag

## Description

The QualysTag class contains properties provided by the Qualys QPS API.

In addition to these, user-assigned properties are also available:

- qualysApiUrl: The URL of the Qualys API endpoint to use, ending at the hostname. Assigned automatically with Get-QualysAsset.

- parentTag: The QualysTag object corresponding to the parent tag of the object.

- childTags: A list of QualysTag objects who have the object as their parent tag.

## Methods

### ToString()

Returns the name of the Qualys tag.

### ToJson()

Returns the Qualys tag object in JSON format.
