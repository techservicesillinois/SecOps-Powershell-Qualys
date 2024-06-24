---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Remove-QualysTagAssignment

## SYNOPSIS

Removes a tag assignment to a Qualys host via the Qualys QPS API.

## SYNTAX

```powershell
Remove-QualysTagAssignment -AssetId <String>
    -TagId <String>
    -Credential <PSCredential>
    [<CommonParameters>]
```

## DESCRIPTION

Remove a tag assignment to the specified host asset, using each object's ID number.

## EXAMPLES

### EXAMPLE 1

```powershell
Remove-QualysTagAssignment -AssetId "123456" -TagId "654321" -Credential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue)
```

### Example 2

```powershell
$credential = Get-Credential
$asset = Remove-QualysTagAssignment -AssetId (Get-QualysAsset -AssetName "Server1").id -TagId (Get-QualysTag -TagName "High Security").id -Credential $Credential
```

## PARAMETERS

### -AssetId

The name of the host asset in Qualys.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: None
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TagId

The ID number of the host asset in Qualys.

```yaml
Type: Int32
Parameter Sets: (All)
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

## NOTES

## RELATED LINKS
