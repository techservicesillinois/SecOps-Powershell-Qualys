---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Set-QualysAssetGroups

## SYNOPSIS
Edits an Asset Group in Qualys

## SYNTAX

```
Set-QualysAssetGroups [-Identity] <String> [[-Title] <String>] [[-SetIPs] <String[]>] [[-AddIPs] <String[]>]
 [[-RemoveIPs] <String[]>] [[-Comments] <String>] [[-Division] <String>] [[-DefaultScanner] <Int32>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Edits an Asset Group in Qualys

## EXAMPLES

### EXAMPLE 1
```
Set-QualysAssetGroups -Identity '7445535' -Title "My Edited Asset Group Title"
```

### EXAMPLE 2
```
Set-QualysAssetGroups -Identity "My Asset Group" -AddIPs "192.168.0.1/24"
```

## PARAMETERS

### -Identity
The ID or Title of the asset group you want to edit

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

### -Title
Edits the Title of the Asset Group

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

### -SetIPs
Removes any pre-existing IPs assigned.
Comma separated IP ranges to assign to asset group.
Ex "128.174.118.0-128.174.118.255", "192.168.0.1/24"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AddIPs
Comma separated IP ranges to add to asset group.
Ex "128.174.118.0-128.174.118.255", "192.168.0.1/24"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveIPs
Comma separated IP ranges to remove from asset group.
Ex "128.174.118.0-128.174.118.255", "192.168.0.1/24"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
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
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultScanner
The ID of the scanner to use as the default scanner for this asset group

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
