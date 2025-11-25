# Remove-VCFCertificateAuthority

## Synopsis

Removes the certificate authority configuration.

## Syntax

```powershell
Remove-VCFCertificateAuthority [-caType] <String> [<CommonParameters>]
```

## Description

The `Remove-VCFCertificateAuthority` cmdlet removes the certificate authority configuration from SDDC Manager.

## Examples

### Example 1

```powershell
Remove-VCFCertificateAuthority
```

This example shows how to remove the certificate authority configuration from SDDC Manager.

## Parameters

### -caType

Specifies the certificate authority type. One of: Microsoft, OpenSSL.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
