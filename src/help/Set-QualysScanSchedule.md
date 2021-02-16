---
external help file: Qualys-help.xml
Module Name: Qualys
online version:
schema: 2.0.0
---

# Set-QualysScanSchedule

## SYNOPSIS
Edit a VM scan schedule

## SYNTAX

```
Set-QualysScanSchedule [-Identity] <String> [[-Title] <String>] [[-Status] <Int32>] [[-OptionProfile] <String>]
 [[-AssetGroups] <String[]>] [[-Scanners] <String>] [-DefaultScanners] [[-Priority] <Int32>] [[-Daily] <Int32>]
 [[-Weekly] <Int32>] [[-Weekdays] <String>] [[-StartDate] <DateTime>] [[-StartHour] <Int32>]
 [[-StartMinute] <Int32>] [[-Recurrence] <Int32>] [[-EndAfterHours] <Int32>] [[-EndAfterMins] <Int32>]
 [[-PauseAfterHours] <Int32>] [[-PauseAfterMins] <Int32>] [[-ResumeInDays] <Int32>] [[-ResumeInHours] <Int32>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Edit a VM scan schedule

## EXAMPLES

### EXAMPLE 1
```
Add-QualysScanSchedule -Title 'Test Schedule' -AssetGroups 'My Asset Group' -DefaultScanners -Daily 20 -StartDate "03/01/2021" -StartHour 0 -StartMinute 0 -EndAfterHours 0 -EndAfterMins 20 -OptionProfile 'Recommended Standard Scan'
```

## PARAMETERS

### -Identity
The ID of the scan schedule to edit

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
The title of the scan schedule

```yaml
Type: String
Parameter Sets: (All)
Aliases: scan_title

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Specify 0 to deactivate the scan schedule, 1 to activate the scan schedule

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: active

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OptionProfile
The id or title of the option profile to use

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

### -AssetGroups
The titles or ids of asset groups containing the hosts to be scanned.
Multiple titles are comma separated
Use only IDs or titles, do not mix and match.

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

### -Scanners
The IDs or friendly names of the scanner appliances to be used or "External" for external scanners.
Multiple entries are comma separated.
Use only IDs or friendly names, do not mix and match

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
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Daily
Have the scan run every specified number of days.
Value is an integer from 1 - 365

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

### -Weekly
Have the scan run every specified number of weeks.
Value is an integer from 1 - 52

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Weekdays
The scan will run only on specified weekdays.
Value is one or more days: sunday, monday, tuesday, wednesday, thursday, friday, saturday.
Multiple days are comma separated.
By default all weekdays are selected

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: Sunday, monday, tuesday, wednesday, thursday, friday, saturday
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
The start date in mm/dd/yyyy format.
By default the start date is the date when the schedule is created

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: start_date

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartHour
The hour when the scan will start.
The hour is aninteger from 0 - 23, where 0 represents 12AM, 7 represents 7AM, and 22 represents 10PM

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: start_hour

Required: False
Position: 12
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartMinute
The minute when a scan will start.
A valid value is an integer from 0 - 59

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: start_minute

Required: False
Position: 13
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurrence
The number of times the scan will be run before it is deactivated.
By default no value is set.
Value is an integer from 1 - 99

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndAfterHours
End a scan after some number of hours.
A valid value is from 0 - 119

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: end_after

Required: False
Position: 15
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndAfterMins
End a scan after some number of minutes.
A valid value is an integer from 0 to 59

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: end_after_mins

Required: False
Position: 16
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PauseAfterHours
Pause a scan after some number of hours.
A valid value is from 0 - 119

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: pause_after_hours

Required: False
Position: 17
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PauseAfterMins
Pause a scan after some number of minutes.
A valid value is an integer from 0 - 59

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: pause_after_mins

Required: False
Position: 18
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResumeInDays
Resume a paused scan in some number of days.
A valid value is an integer from 0 - 9

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: resume_in_days

Required: False
Position: 19
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResumeInHours
Resume a paused scan in some number of hours.
A valid value is an integer from 0 - 23

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: resume_in_hours

Required: False
Position: 20
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
