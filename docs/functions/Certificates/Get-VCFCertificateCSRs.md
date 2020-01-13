# Get-VCFCertificateCSRs

### Synopsis
Get available CSR(s)

### Syntax
```
Get-VCFCertificateCSRs -domainName <string>
```

### Description
Gets available CSRs from SDDC Manager

### Examples
#### Example 1
```
Get-VCFCertificateCSRs -domainName MGMT | ConvertTo-Json
```
This example gets a list of CSRs and displays them in JSON format

### Parameters

#### -domainName
- Name of the Management Domain

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Notes

### Related Links
