# Connect-CloudBuilder

## Synopsis

Request an authentication token from a VMware Cloud Builder instance.

## Syntax

```powershell
Connect-CloudBuilder [-fqdn] <String> [[-username] <String>] [[-password] <String>] [-skipCertificateCheck]
 [<CommonParameters>]
```

## Description

The Connect-CloudBuilder cmdlet connects to the specified VMware Cloud Builder instance and stores the credentials
in a base64 string.

???+ note

    It is required once per session before running all other cmdlets.

## Examples

### Example 1

```powershell
Connect-CloudBuilder -fqdn sfo-cb01.sfo.rainpole.io -username admin -password VMware1!
```

This example shows how to connect to the VMware Cloud Builder instance.

## Parameters

### -fqdn

Specifies the fully qualified domain name or IP address of the VMware Cloud Builder instance.

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

Specifies the username to connect to the VMware Cloud Builder instance (admin).

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

### -password

Specifies the password for the user to connect to the VMware Cloud Builder instance (admin).

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

### -skipCertificateCheck

Specifies whether to skip the certificate check for the VMware Cloud Builder instance.

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

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
