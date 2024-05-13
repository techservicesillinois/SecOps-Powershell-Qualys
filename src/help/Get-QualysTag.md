---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Get-QualysTag

## SYNOPSIS

Returns an object or array of class QualysTag using the Qualys QPS API.

## SYNTAX

```powershell
Get-QualysTag -TagId <Int32>
    [-InputCredential <PSCredential>]
    [-InputQualysApiUrl <String>]
    [<CommonParameters>]
```

```powershell
Get-QualysTag -TagName <String>
    [-InputCredential <PSCredential>]
    [-InputQualysApiUrl <String>]
    [<CommonParameters>]
```

```powershell
Get-QualysTag -ParentTagId <Int32>
    [-InputCredential <PSCredential>]
    [-InputQualysApiUrl <String>]
    [<CommonParameters>]
```

## DESCRIPTION

Returns a QualysTag object or list by searching the QPS API based on Asset ID number or name.

## EXAMPLES

### EXAMPLE 1

```powershell
$tag = Get-QualysTag -TagName "Server1" -InputCredential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue) -InputQualysApiUrl "https://qualysapi.qg2.apps.qualys.com"
```

### Example 2

```powershell
$credential = Get-Credential
$QualysApiUrl = "https://qualysapi.qg2.apps.qualys.com"
$tag = Get-QualyTag -TagId 654321
```

### Example 3

```powershell
$credential = Get-Credential
$QualysApiUrl = "https://qualysapi.qg2.apps.qualys.com"
$tags = Get-QualyTag -ParentTagId 987654
```

## PARAMETERS

### -AssetName

The name of the tag in Qualys.

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

### -TagId

The ID number of the tag in Qualys.

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

### -ParentTagId

The ID number of the parent tag in Qualys.

```yaml
Type: Int32
Parameter Sets: parent
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

QualysTag

## NOTES

## RELATED LINKS
