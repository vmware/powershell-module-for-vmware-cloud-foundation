# Request-VCFToken

## Synopsis

Request an authentication token from SDDC Manager.

## Syntax

```powershell
Request-VCFToken [-fqdn] <String> [[-username] <String>] [[-password] <String>] [-skipCertificateCheck]
 [<CommonParameters>]
```

## Description

The Request-VCFToken cmdlet connects to the specified SDDC Manager and requests API access and refresh tokens.
It is required once per session before running all other cmdlets.

## Examples

### Example 1

```powershell
Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username administrator@vsphere.local -password VMw@re1!
```

This example shows how to connect to SDDC Manager to request API access and refresh tokens.

### Example 2

```powershell
Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username admin@local -password VMw@re1!VMw@re1!
```

This example shows how to connect to SDDC Manager using local account `admin@local`.

## Parameters

### -fqdn

Specifies the fully qualified domain name or IP Address of the SDDC Manager instance.

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

Specifies the username to connect to the SDDC Manager instance.

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

Specifies the password for the user to connect to the SDDC Manager instance.

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

Specifies whether to skip the certificate check for the SDDC Manager instance.

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
