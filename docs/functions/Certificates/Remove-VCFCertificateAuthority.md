# Remove-VCFCertificateAuthority

### Synopsis
Deletes certificate authority configuration

### Syntax
```
Remove-VCFCertificateAuthority -caType <string>
```

### Description
The Remove-VCFCertificateAuthority cmdlet removes the certificate authority configuration from the connected SDDC Manager

### Examples
#### Example 1
```
Remove-VCFCertificateAuthority -caType Microsoft
```
This example removes the Micosoft certificate authority configuration from the connected SDDC Manager

### Parameters

#### -caType
Pass the Certificate Authority type

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accepted value: OpenSSL, Microsoft
```

### Notes

### Related Links
