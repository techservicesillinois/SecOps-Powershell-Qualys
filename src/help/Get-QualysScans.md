---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Get-QualysScans

## SYNOPSIS
List vulnerability scans in the user's account.
By default the output lists unprocessed scans launched in the past 30 days

## SYNTAX

```
Get-QualysScans [[-ScanRef] <String>] [[-State] <String>] [-Processed] [[-Type] <String>] [[-Target] <String>]
 [[-UserLogin] <String>] [[-LaunchedAfterDate] <String>] [[-LaunchedBeforeDate] <String>] [<CommonParameters>]
```

## DESCRIPTION
List vulnerability scans in the user's account.
By default the output lists unprocessed scans launched in the past 30 days

## EXAMPLES

### EXAMPLE 1
```
Get-QualysScans
Get-QualysScans -LaunchedBeforeDate '2021-04-05T00:00:00Z' -LaunchedAfterDate '2021-04-03T00:00:00Z' -State 'Canceled, Finished, Error' -Processed
```

## PARAMETERS

### -ScanRef
Show only a scan with a certain scan reference code.
For a vulnerability scan, the format is: scan/987659876.19876
For a compliance scan the format is: compliance/98765456.12345

```yaml
Type: String
Parameter Sets: (All)
Aliases: scan_ref

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Show only one or more scan states.
A valid value is: Running, Paused, Canceled, Finished, Error, Queued

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

### -Processed
Specify to show only scans that have been processed.
Processed scans are not included by default

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

### -Type
Show only a certain scan type.
A valid value is: On-Demand, Scheduled, or API

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

### -Target
Show only one or more target IP addresses.
Multiple IP addresses and/or ranges may be entered.
Multiple entries are comma separated.
You may enter an IP address range using the hyphen (-) to separate the start and end IP address, as in:
10.10.10.1-10.10.10.2

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

### -UserLogin
Show only scans launched by a particular user login

```yaml
Type: String
Parameter Sets: (All)
Aliases: user_login

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LaunchedAfterDate
Show only scans launched after a certain date and time.
The date/time is specified in yyyy-MM-dd\[THH:mm:ssZ\] format (UTC/GMT), like "2007-07-01" or "2007-01-25T23:12:00Z"

```yaml
Type: String
Parameter Sets: (All)
Aliases: launched_after_datetime

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LaunchedBeforeDate
Show only scans launched before a certain date and time.
The date/time is specified in yyyy-MM-dd\[THH:mm:ssZ\] format (UTC/GMT), like "2007-07-01" or "2007-01-25T23:12:00Z"

```yaml
Type: String
Parameter Sets: (All)
Aliases: launched_before_datetime

Required: False
Position: 7
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
