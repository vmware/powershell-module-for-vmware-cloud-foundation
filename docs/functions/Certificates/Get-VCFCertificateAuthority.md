# Get-VCFCertificateAuthority

### Synopsis
Get certificate authorities information

### Syntax
```
Get-VCFCertificateAuthority -caType <string>
```

### Description
The Get-VCFCertificateAuthority cmdlet retrieves the certificate authorities information for the connected SDDC Manager

### Examples
#### Example 1
```
Get-VCFCertificateAuthority
```
This example shows how to get the certificate authority configuration from the connected SDDC Manager

#### Example 2
```
Get-VCFCertificateAuthority | ConvertTo-Json
```
This example shows how to get the certificate authority configuration from the connected SDDC Manager 
and output to Json format

#### Example 3
```
Get-VCFCertificateAuthority -caType Microsoft
```
This example shows how to get the certificate authority configuration for a Microsoft Certificate Authority from the
connected SDDC Manager

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
