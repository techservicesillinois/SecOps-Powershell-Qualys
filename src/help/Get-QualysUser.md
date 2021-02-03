---
external help file: Qualys-help.xml
Module Name: Qualys
online version:
schema: 2.0.0
---

# Get-QualysUser

## SYNOPSIS
Returns users from Qualys

## SYNTAX

```
Get-QualysUser [-Credential] <PSCredential> [[-ExternalID] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns users from Qualys

## EXAMPLES

### EXAMPLE 1
```
Get-QualysUser
```

## PARAMETERS

### -Credential
This API call only supports basic HTTP authentication.
You must provide your credentials separately for this function.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExternalID
Specifies user accounts with an external ID value that contains this string

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
