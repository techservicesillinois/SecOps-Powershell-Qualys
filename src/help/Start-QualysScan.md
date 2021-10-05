---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Start-QualysScan

## SYNOPSIS
Launch vulnerability scan in the user's account.
Only targeting asset groups is supported currently.
Support for targeting by IPs to be added later.

## SYNTAX

```
Start-QualysScan [[-Title] <String>] [[-IPs] <String[]>] [[-AssetGroups] <String[]>] [[-ExcludeIPs] <String[]>]
 [[-Scanners] <String>] [-DefaultScanners] [[-Priority] <Int32>] [[-OptionProfile] <String>]
 [[-FQDN] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Launch vulnerability scan in the user's account.
Only targeting asset groups is supported currently.
Support for targeting by IPs to be added later.

## EXAMPLES

### EXAMPLE 1
```
Start-QualysScan -Title 'Test Scan' -AssetGroups 'Test Asset Group'
```

## PARAMETERS

### -Title
{{ Fill Title Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: scan_title

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPs
The IP addresses to be scanned.
You may enter individual IP addresses and/or ranges.
Multiple entries are comma separated

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

### -AssetGroups
The titles or ids of asset groups containing the hosts to be scanned.
Multiple titles are comma separated
Use only IDs or titles, do not mix and match.

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

### -ExcludeIPs
{{ Fill ExcludeIPs Description }}

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

### -Scanners
The IDs or friendly names of the scanner appliances to be used or "External" for external scanners.
Multiple entries are comma separated.
Use only IDs or friendly names, do not mix and match

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

### -DefaultScanners
Specify to use the default scanner in each target asset group

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Priority
Specify a value of 0 - 9 to set a processing priority level for the scan

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OptionProfile
{{ Fill OptionProfile Description }}

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

### -FQDN
The target FQDN for a vulnerability scan.
Multiple values are comma separated.
You can specify FQDNs in combination with IPs and asset groups

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
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
