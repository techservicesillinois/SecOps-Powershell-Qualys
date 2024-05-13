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

### Assign([QualysAsset]$QualysAsset, [PSCredential]$inputCredential)

Assigns the tag to the Qualys asset.

### Unassign([QualysAsset]$QualysAsset, [PSCredential]$inputCredential)

Unassigns the tag to the Qualys asset.

### AssignById([Int32]$assetId, [PSCredential]$inputCredential)

Assigns the tag to the Qualys asset based on the asset's ID.

### UnassignById([Int32]$assetId, [PSCredential]$inputCredential)

Unassigns the tag to the Qualys asset based on the asset's ID.

### AssignByName([String]$assetId, [PSCredential]$inputCredential)

Assigns the tag to the Qualys asset based on the asset's name.

### UnassignByName([String]$assetId, [PSCredential]$inputCredential)

Unassigns the tag to the Qualys asset based on the asset's name.

### GetParentTag([Switch]$Recursive, [PSCredential]$inputCredential)

Add the parent QualysTag object to the tag's parentTag property. Will add grandparent tag object to the parent tag's parentTag property if recursive.

### GetChildTags([Switch]$Recursive, [PSCredential]$inputCredential)

Add the child QualysTag object list to the tag's childTags property. Will add grandchild tag objects to the child tag's childTags property if recursive.
