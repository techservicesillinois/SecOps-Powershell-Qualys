---
external help file: Qualys-help.xml
Module Name: Qualys
online version:
schema: 2.0.0
---

# Get-QualysScanSummary

## SYNOPSIS
List all the scans launched since the date and identifies hosts that were included in the scan target but not scanned for some reason.

## SYNTAX

```
Get-QualysScanSummary [-ScanDateSince] <String> [[-ScanDateTo] <String>] [-IncludeDead] [-IncludeCancelled]
 [<CommonParameters>]
```

## DESCRIPTION
List all the scans launched since the date and identifies hosts that were included in the scan target but not scanned for some reason.

## EXAMPLES

### EXAMPLE 1
```
Get-QualysScanSummary -ScanDateSince '2021-03-03' -ScanDateTo '2021-03-03' -IncludeCancelled -IncludeDead
```

## PARAMETERS

### -ScanDateSince
Include scans started since a certain date.
Specify the date in YYYY-MM-DD format.
The date must be less than or equal to today's date.

```yaml
Type: String
Parameter Sets: (All)
Aliases: scan_date_since

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScanDateTo
Include scans started up to a certain date.
Specify the date in YYYY-MM-DD format.
The date must be more than or equal to scan_date_since, and less than or equal to today's date.

```yaml
Type: String
Parameter Sets: (All)
Aliases: scan_date_to

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeDead
Set to 0 if you do not want to include dead hosts in the output.
Dead hosts are included by default.

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

### -IncludeCancelled
Set to 1 to include cancelled hosts in the output.
Cancelled hosts are not included by default.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
