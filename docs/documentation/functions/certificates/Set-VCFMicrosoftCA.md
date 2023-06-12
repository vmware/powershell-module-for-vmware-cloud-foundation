# Set-VCFMicrosoftCA

## Synopsis

Configures Microsoft Certificate Authority integration.

## Syntax

```powershell
Set-VCFMicrosoftCA [-serverUrl] <String> [-username] <String> [-password] <String> [-templateName] <String>
 [<CommonParameters>]
```

## Description

Configures the Microsoft Certificate Authorty integration with SDDC Manager.

## Examples

### Example 1

```powershell
Set-VCFMicrosoftCA -serverUrl "https://rpl-dc01.rainpole.io/certsrv" -username Administrator -password "VMw@re1!" -templateName VMware
```

This example shows how to configure a Microsoft Certificate Authority integration with SDDC Manager.

## Parameters

### -serverUrl

Specifies the HTTPS URL for the Microsoft Certificate Authority.

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

### -username

Specifies the username used to authenticate to the Microsoft Certificate Authority.

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

### -password

Specifies the password used to authenticate to the Microsoft Certificate Authority.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -templateName

Specifies the name of the certificate template used on the Microsoft Certificate Authority.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
