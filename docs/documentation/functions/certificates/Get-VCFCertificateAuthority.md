# Get-VCFCertificateAuthority

## Synopsis

Retrieves the certificate authority information.

## Syntax

```powershell
Get-VCFCertificateAuthority [[-caType] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFCertificateAuthority` cmdlet retrieves the certificate authority configuration from SDDC Manager.

## Examples

### Example 1

```powershell
Get-VCFCertificateAuthority
```

This example shows how to retrieve the certificate authority configuration from SDDC Manager.

### Example 2

```powershell
Get-VCFCertificateAuthority | ConvertTo-Json
```

This example shows how to retrieve the certificate authority configuration from SDDC Manager and convert the output to JSON.

### Example 3

```powershell
Get-VCFCertificateAuthority -caType Microsoft
```

This example shows how to retrieve the certificate authority configuration for a Microsoft Certificate Authority from SDDC Manager.

## Parameters

### -caType

Specifies the certificate authority type. One of: Microsoft, OpenSSL.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
