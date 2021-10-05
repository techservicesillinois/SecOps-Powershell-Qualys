---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Add-QualysHostAssets

## SYNOPSIS
Adds one or more networks into Qualys Host Assets

## SYNTAX

```
Add-QualysHostAssets [-Networks] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Adds one or more networks into Qualys Host Assets

## EXAMPLES

### EXAMPLE 1
```
Add-QualysHostAssets -Networks "128.174.118.0-128.174.118.255, 192.168.0.1/24"
```

## PARAMETERS

### -Networks
Comma separated string of networks by IP range (192.168.0.1-192.168.0.254) or CIDR notation (192.168.0.1/24)

```yaml
Type: String[]
Parameter Sets: (All)
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
