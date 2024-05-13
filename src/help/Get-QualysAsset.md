---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Get-QualysAsset

## SYNOPSIS

Returns an object or array of class QualysAsset using the Qualys QPS API.

## SYNTAX

```powershell
Get-QualysAsset -AssetId <Int32>
    [-InputCredential <PSCredential>]
    [-InputQualysApiUrl <String>]
    [<CommonParameters>]
```

```powershell
Get-QualysAsset -AssetName <String>
    [-InputCredential <PSCredential>]
    [-InputQualysApiUrl <String>]
    [<CommonParameters>]
```

```powershell
Get-QualysAsset -TagName <String>
    [-InputCredential <PSCredential>]
    [-InputQualysApiUrl <String>]
    [<CommonParameters>]
```

## DESCRIPTION

Returns a QualysAsset object by searching the QPS API based on Asset ID number, tag name, or name.

## EXAMPLES

### EXAMPLE 1

```powershell
$asset = Get-QualysAsset -AssetName "Server1" -InputCredential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue) -InputQualysApiUrl "https://qualysapi.qg2.apps.qualys.com"
```

### Example 2

```powershell
$credential = Get-Credential
$QualysApiUrl = "https://qualysapi.qg2.apps.qualys.com"
$asset = Get-QualysAsset -AssetId 123456
```

### Example 3

```powershell
$credential = Get-Credential
$QualysApiUrl = "https://qualysapi.qg2.apps.qualys.com"
$assets = Get-QualysAsset -TagName "Important"
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
Type: Int32
Parameter Sets: id
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TagName

The tag name in Qualys with which the returned hosts are assigned.

```yaml
Type: String
Parameter Sets: tagName
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputCredential

The credential to be used for HTTP Basic authorization to the Qualys API.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Position: 1
Default value: $QualysApiUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

QualysAsset

## NOTES

## RELATED LINKS
