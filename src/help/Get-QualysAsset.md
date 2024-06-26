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
Get-QualysAsset -AssetId <Int64>
    -Credential <PSCredential>
    [<CommonParameters>]
```

```powershell
Get-QualysAsset -AssetName <String>
    -Credential <PSCredential>
    [<CommonParameters>]
```

```powershell
Get-QualysAsset -TagName <String>
    -Credential <PSCredential>
    [<CommonParameters>]
```

## DESCRIPTION

Returns a QualysAsset object by searching the QPS API based on Asset ID number, tag name, or name.

## EXAMPLES

### EXAMPLE 1

```powershell
$asset = Get-QualysAsset -AssetName "Server1" -Credential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue)
```

### Example 2

```powershell
$credential = Get-Credential
$QualysApiUrl = "https://qualysapi.qg2.apps.qualys.com"
$asset = Get-QualysAsset -AssetId 123456 -Credential $credential
```

## PARAMETERS

### -AssetName

The name of the host asset in Qualys.

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: True
Position: None
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetId

The ID number of the host asset in Qualys.

```yaml
Type: Int64
Parameter Sets: id
Aliases:

Required: True
Position: None
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
Position: None
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential

The credential to be used for HTTP Basic authorization to the Qualys API.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: None
Default value: $Credential
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
