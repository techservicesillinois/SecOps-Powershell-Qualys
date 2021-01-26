---
external help file: Qualys-help.xml
Module Name: Qualys
online version:
schema: 2.0.0
---

# Get-QualysScanSchedules

## SYNOPSIS
List schedules for vulnerability scans

## SYNTAX

```
Get-QualysScanSchedules [[-ID] <String>] [-Active] [-Deactivated] [<CommonParameters>]
```

## DESCRIPTION
List schedules for vulnerability scans

## EXAMPLES

### EXAMPLE 1
```
Get-QualysScanSchedules -Active
```

## PARAMETERS

### -ID
The ID of the scan schedule you want to display.

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

### -Active
Specify for active schedules only

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

### -Deactivated
Specify for deactivated schedules only

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
