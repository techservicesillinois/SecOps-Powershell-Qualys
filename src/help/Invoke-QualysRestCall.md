---
external help file: UofIQualys-help.xml
Module Name: UofIQualys
online version:
schema: 2.0.0
---

# Invoke-QualysRestCall

## SYNOPSIS
Makes a REST method call on the given relative URI for Qualys.
Utilizes credentials created with New-QualysSession.

## SYNTAX

```
Invoke-QualysRestCall [-RelativeURI] <String> [-Method] <String> [-Body] <Hashtable>
 [[-Credential] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Makes a REST method call on the given relative URI for Qualys.
Utilizes credentials created with New-QualysSession.

## EXAMPLES

### EXAMPLE 1
```
$Body = @{
     action = 'list'
     echo_request = '1'
 }
 Invoke-QualysRestCall -RelativeURI asset/ip/ -Method GET -Body $Body
 This will return an array of all host assets (IPs) in Qualys
```

## PARAMETERS

### -RelativeURI
The relativeURI you wish to make a call to.
Ex: asset/ip/

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

### -Method
Method of the REST call Ex: GET

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

### -Body
Body of the REST call as a hashtable

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Optionally used for making REST calls that require Basic Authentication

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
