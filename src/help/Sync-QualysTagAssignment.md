---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Sync-QualysTagAssignment

## SYNOPSIS

Synchronizes tags in Qualys from an external source of truth.

## SYNTAX

```powershell
Sync-QualysTagAssignment -InputAsset <QualysAsset>
    -CategoryDefinitions <Hashtable>
    [-InputCredential <PSCredential>]
    [-InputQualysApiUrl <String>]
    [<CommonParameters>]
```

## DESCRIPTION

This function takes a single QualysAsset object, or a piped list of QualysAsset objects, and synchronizes the tags on each asset to match their external tags (which may originate from a virtualization platform or other source of truth). See notes for important usage information.

## EXAMPLES

### EXAMPLE 1

```powershell
$CategoryDefinitions = '{
    "Environment": [
        "Production Environment",
        "Test Environment",
        "Development Environment"
    ],
    "Security": [
        "High",
        "Medium",
        "Low"
    ]
}' | ConvertFrom-Json -AsHashtable

$credential = Get-Credential
$QualysApiUrl = "https://qualysapi.qg2.apps.qualys.com"

$Asset = Get-QualysAsset -AssetName "Server1"

$vm = Get-VM -Name $Asset.name

$vmwareTags = ($vm | Get-TagAssignment).Tag

# Create PSCustomObject with tag name and category
$Asset.vtags = foreach ($tag in $vmwareTags) {
    [PSCustomObject]@{
        TagName  = $tag.Name.ToString()
        Category = $tag.Category.ToString()
    }
}

Sync-QualysTagAssignment -InputAsset $Asset -CategoryDefinitions $CategoryDefinitions
```

### Example 2

```powershell
$credential = Get-Credential
$QualysApiUrl = "https://qualysapi.qg2.apps.qualys.com"

$assets = Get-QualysAssetInventory

foreach ($asset in $assets) {
    $vm = Get-VM -Name $Asset.name

    $vmwareTags = ($vm | Get-TagAssignment).Tag

    # Create PSCustomObject with tag name and category
    $Asset.vtags = foreach ($tag in $vmwareTags) {
        [PSCustomObject]@{
            TagName  = $tag.Name.ToString()
            Category = $tag.Category.ToString()
        }
    }
}

$syncReport = ($assets | Sync-QualysTagAssignment -CategoryDefinitions $CategoryDefinitions)
```

## PARAMETERS

### -InputAsset

The QualysAsset object or piped list of QualysAssets to synchronize.

```yaml
Type: QualysAsset
Parameter Sets: (All)
Aliases:

Required: True
Position: None
Default value: None
Accept pipeline input: True
Accept wildcard characters: False
```

### -InputCredential

The credential to be used for HTTP Basic authorization to the Qualys API.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: None
Default value: $Credential
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputQualysApiUrl

The base URL for endpoint API connections, ending with the hostname. Ex. "<https://qualysapi.qg3.apps.qualys.com>"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: None
Default value: $QualysApiUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### -CategoryDefinitions

The table of tag categories and their permissible tag names.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: None
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

QualysAsset or QualysAsset[] (when piped).

## OUTPUTS

`$responses, a hashtable of information about tags added, removed, existing, and issues.

## NOTES

In order to operate, each QualysAsset object must have external tags added to its vtags property in the format of a list of objects with a Category and TagName property. A successful automation implementation that uses this function will add external tags to asset objects (see examples for inspiration).

The function requires a definition of tag categories in the external source of truth that the invoker of the function wishes to synchronize. The CategoryDefinitions parameter can be used to supply a hashtable with category name as a key, and value set to a list of possible tag names in that category.

Qualys has no concept of tag category (in which an object may only have zero or one tag of a given category), but functionally, the Qualys structure of parent and child tags functions interoperably. In order to use this function, it is recommended to structure tags of a given category to have the same parent tag in Qualys; for instance, a "Security Level" category is a parent tag with child tags "Low", "Medium", and "High".

The QPS API can be slow at times, with tag searches taking sometimes a few seconds to return results. To accommodate the synchronization of many assets, when a list of assets is piped to this function, the function caches tags as it requires them. Tag objects are fetched from the cache when possible, accelerating synchronizations of large inventories.

## RELATED LINKS
