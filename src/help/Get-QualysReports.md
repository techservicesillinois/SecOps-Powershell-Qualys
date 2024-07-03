---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Get-QualysReports

## SYNOPSIS
List reports in the user's account.
By default the output lists all reports.

## SYNTAX

```
Get-QualysReports [[-ID] <String>] [[-State] <String>] [[-UserLogin] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
List reports in the user's account.

## EXAMPLES

### EXAMPLE 1
```
Get-QualysReports
Get-QualysReports -ID '36775225'
Get-QualysReports -State 'Finished'
Get-QualysReports -User 'theun_jd9'
```

## PARAMETERS

### -ID
Specifies a report ID of a saved report.
When specified, only information on the selected report will be included.

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

### -State
Specifies that reports with a certain state will be included in the output.
By default, all states are included.
A valid value is: Running, Finished, Submitted, Canceled, or Errors.

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

### -UserLogin
This parameter is used to restrict the output to reports launched by the specified user login ID.

```yaml
Type: String
Parameter Sets: (All)
Aliases: user_login

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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
