---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Get-QualysAsset

## SYNOPSIS

Returns an object of class QualysAsset using the Qualys QPS API.

## SYNTAX

```powershell
Get-QualysHostAssets [-AssetID <Integer>]
    [-InputUsername <String>]
    [-InputKeyvault <String>]
    [-InputSecretName <String>]
    [-InputQualysApiUrl <String>]
    [<CommonParameters>]
```

```powershell
Get-QualysHostAssets [-AssetName <String>]
    [-InputUsername <String>]
    [-InputKeyvault <String>]
    [-InputSecretName <String>]
    [-InputQualysApiUrl <String>]
    [<CommonParameters>]
```

## DESCRIPTION

Returns a QualysAsset object by searching the QPS API based on Asset ID number or name.

## EXAMPLES

### EXAMPLE 1

```powershell
$username = "QualysAPIUser"
$keyvault = "MyAzKeyVault"
$secretName = "QualysAPIUserCredential"
$qualysApiUrl = "https://qualysapi.qualys.com"
$asset = Get-QualysAsset -AssetName "Server1"
```

## PARAMETERS

### -AssetName

The name of the host asset in Qualys.

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetId

The ID number of the host asset in Qualys.

```yaml
Type: String
Parameter Sets: id
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```



### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
