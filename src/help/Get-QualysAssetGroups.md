---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Get-QualysAssetGroups

## SYNOPSIS
Returns one or all Asset Groups in Qualys

## SYNTAX

```
Get-QualysAssetGroups [[-Identity] <String>] [[-Limit] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Returns one or all Asset Groups in Qualys

## EXAMPLES

### EXAMPLE 1
```
Get-QualysAssetGroups
Returns all Asset Groups
```

### EXAMPLE 2
```
Get-QualysAssetGroups -Identity "7270750"
Returns the Asset Group with this ID
```

### EXAMPLE 3
```
Get-QualysAssetGroups -Identity "Test"
Returns the Asset Group titled "Test"
```

## PARAMETERS

### -Identity
The Title or ID of the Asset Group in Qualys

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Number of items to return.
By default this is 0 (all)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
