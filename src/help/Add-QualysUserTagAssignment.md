---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Add-QualysUserTagAssignment

## SYNOPSIS
Adds a tag to an user in Qualys.

## SYNTAX

```
Add-QualysUserTagAssignment [-UserId] <Int32> [-Tags] <String[]> [-Credential] <PSCredential>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function takes a User ID and a Tag name and adds the tag to the user.

## EXAMPLES

### EXAMPLE 1
```
Add-QualysTagAssignment -UserID "566158438" -Tag "0001-ctav-net_CDB-7725" -Credential $credential
```

## PARAMETERS

### -UserId
The ID of the user to add the tag to.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
An array of Names or IDs of tags to add to the user.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
The credential object to log into Qualys.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
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
The easiest way to get the UserID is to use the Get-QualysUser function.
The easiest way to get the tag ID is to use the Get-QualysTag function.

## RELATED LINKS
