---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Add-QualysUser

## SYNOPSIS
Adds a new user to Qualys

## SYNTAX

```
Add-QualysUser [-Credential] <PSCredential> [-SendEmail] [-Role] <String> [[-BusinessUnit] <String>]
 [[-AssetGroups] <String[]>] [-FirstName] <String> [-LastName] <String> [-Title] <String> [-Email] <String>
 [-Phone] <String> [-Address] <String> [-City] <String> [-Country] <String> [[-State] <String>]
 [[-ExternalID] <String>] [<CommonParameters>]
```

## DESCRIPTION
Adds a new user to Qualys

## EXAMPLES

### EXAMPLE 1
```
$NewUserSplat = @{
    Phone = '555-555-555'
    Address = 'University of Illinois'
    City = 'Urbana'
    Country = 'United States of America'
    State = 'Illinois'
    Role = 'scanner'
    FirstName = 'Jane'
    LastName = 'Doe'
    Title = 'Test User'
    Email = 'JaneDoe@test.null'
    Credential = $Credential
}
Add-QualysUser @NewUserSplat
```

## PARAMETERS

### -Credential
This API call only supports basic HTTP authentication.
You must provide your credentials separately for this function.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SendEmail
Specifies whether the new user will receive an email notification with a secure link to their login credentials.

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

### -Role
Specifies the user role.
A valid value is: manager, unit_manager, scanner, reader, contact or administrator.

```yaml
Type: String
Parameter Sets: (All)
Aliases: user_role

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BusinessUnit
Specifies the user's business unit.

```yaml
Type: String
Parameter Sets: (All)
Aliases: business_unit

Required: False
Position: 3
Default value: Unassigned
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetGroups
Specifies the asset groups assigned to the user, when theuser role is Scanner, Reader or Contact.

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

### -FirstName
Specifies the user's first name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: first_name

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastName
Specifies the user's last name

```yaml
Type: String
Parameter Sets: (All)
Aliases: last_name

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
Specifies the user's job title.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
Specifies the user's email address.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Phone
Specifies the user's phone number.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Address
Specifies the user's address.

```yaml
Type: String
Parameter Sets: (All)
Aliases: address1

Required: True
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -City
Specifies the user's city.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Country
Specifies the user's country.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Specifies the user's state.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExternalID
Set a custom External ID (required for SSO)

```yaml
Type: String
Parameter Sets: (All)
Aliases: external_id

Required: False
Position: 14
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
