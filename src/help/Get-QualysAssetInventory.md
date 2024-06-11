---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Get-QualysAsset

## SYNOPSIS

Returns an array of objects of class QualysAsset using the Qualys QPS API.

## SYNTAX

```powershell
Get-QualysAssetInventory -Credential <PSCredential>
    [-BatchSize <int>]
    [<CommonParameters>]
```

## DESCRIPTION

Returns an array of QualysAsset objects by searching the QPS API.

The QPS API limits results to 1000 objects, and may time out returning this many objects. This can be controlled by setting the BatchSize parameter.

All assets visible to the credential will be returned.

## EXAMPLES

### EXAMPLE 1

```powershell
$assets = Get-QualysAssetInventory -Credential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue)
```

### Example 2

```powershell
$credential = Get-Credential
$assets = Get-QualysAssetInventory -BatchSize 500 -Credential $credential
```

## PARAMETERS

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

### -BatchSize

The size of the batch of results to return with each API request. Default 1000.

```yaml
Type: Integer
Parameter Sets: (All)
Aliases:

Required: False
Position: None
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

QualysAsset[]

## NOTES

## RELATED LINKS
