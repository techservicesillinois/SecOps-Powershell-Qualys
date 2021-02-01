---
external help file: Qualys-help.xml
Module Name: Qualys
online version:
schema: 2.0.0
---

# Add-QualysAssetGroups

## SYNOPSIS
Adds an Asset Group to Qualys

## SYNTAX

```
Add-QualysAssetGroups [-Title] <String> [[-IPs] <String[]>] [[-Comments] <String>] [[-Division] <String>]
 [[-DefaultScanner] <String>] [<CommonParameters>]
```

## DESCRIPTION
Adds an Asset Group to Qualys

## EXAMPLES

### EXAMPLE 1
```
Add-QualysAssetGroups -Title "My Asset Group"
```

### EXAMPLE 2
```
Add-QualysAssetGroups -Title "My Asset Group" -IPs "192.168.0.1/24"
```

## PARAMETERS

### -Title
The Title of the Asset Group

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

### -IPs
Comma separated IP ranges to add to new asset group.
Ex "128.174.118.0-128.174.118.255", "192.168.0.1/24"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comments
Description or comments about the group; max 255 characters

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Division
The Division of the Asset Group, typically the Owner Code from CDB

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultScanner
The ID of the scanner to use as the default scanner for this asset group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
