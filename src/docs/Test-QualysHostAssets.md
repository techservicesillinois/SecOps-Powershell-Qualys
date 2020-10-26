---
external help file: Qualys-help.xml
Module Name: Qualys
online version:
schema: 2.0.0
---

# Test-QualysHostAssets

## SYNOPSIS
Returns a true or false value if the network is present or not in the Qualys Host Assets

## SYNTAX

```
Test-QualysHostAssets [-Network] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns a true or false value if the network is present or not in the Qualys Host Assets

## EXAMPLES

### EXAMPLE 1
```
Test-QualysHostAssets -Network "128.174.118.0-128.174.118.255"
```

## PARAMETERS

### -Network
Network as a range of addresses i.e.
"128.174.118.0-128.174.118.255"

```yaml
Type: String
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

### System.Boolean
## NOTES

## RELATED LINKS
