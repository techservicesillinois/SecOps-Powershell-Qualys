---
external help file: Qualys-help.xml
Module Name: Qualys
online version:
schema: 2.0.0
---

# Set-QualysUser

## SYNOPSIS
Adds a new user to Qualys

## SYNTAX

```
Set-QualysUser [-Credential] <PSCredential> [-Login] <String> [[-AssetGroups] <String[]>]
 [[-FirstName] <String>] [[-LastName] <String>] [[-Title] <String>] [[-Email] <String>] [[-Phone] <String>]
 [[-Address] <String>] [[-City] <String>] [[-Country] <String>] [[-State] <String>] [[-ExternalID] <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds a new user to Qualys

## EXAMPLES

### EXAMPLE 1
```
Set-QualysUser -Credential $Credential -Login testuser -AssetGroups TestGroup
```

### EXAMPLE 2
```
$SetUserSplat = @{
    Login = testuser
    Phone = '555-555-555'
    Address = 'University of Illinois'
    city = 'Urbana'
    country = 'United States of America'
    state = 'Illinois'
    FirstName = 'Jane'
    LastName = 'Doe'
    Title = 'Test User'
    email = 'JaneDoe@test.null'
    Credential = $Credential
}
Set-QualysUser @SetUserSplat
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

### -Login
Specifies the Qualys user login of the user account you wish to edit.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
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
Position: 3
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

Required: False
Position: 4
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

Required: False
Position: 5
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

Required: False
Position: 6
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

Required: False
Position: 7
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

Required: False
Position: 8
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

Required: False
Position: 9
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

Required: False
Position: 10
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

Required: False
Position: 11
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
Position: 12
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
Position: 13
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
