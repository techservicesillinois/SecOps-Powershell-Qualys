---
external help file: Qualys-help.xml
Module Name: Qualys
online version:
schema: 2.0.0
---

# Start-QualysScan

## SYNOPSIS
Launch vulnerability scan in the user's account

## SYNTAX

```
Start-QualysScan [[-Title] <String>] [[-IPs] <String[]>] [[-AssetGroups] <String[]>] [[-ExcludeIPs] <String[]>]
 [[-Scanners] <String>] [-DefaultScanners] [[-Priority] <Int32>] [[-OptionProfile] <String>]
 [[-FQDN] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Launch vulnerability scan in the user's account

## EXAMPLES

### EXAMPLE 1
```
Get-QualysScans
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
{{ Fill AssetGroups Description }}

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
{{ Fill DefaultScanners Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
