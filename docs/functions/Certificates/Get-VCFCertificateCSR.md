# Get-VCFCertificateCSR

### Synopsis
Get available CSR(s)

### Syntax
```
Get-VCFCertificateCSRs -domainName <string>
```

### Description
The Get-VCFCertificateCSR cmdlet gets the available CSRs that have been created on SDDC Manager

### Examples
#### Example 1
```
Get-VCFCertificateCSRs -domainName MGMT
```
This example gets a list of CSRs and displays the output

#### Example 2
```
Get-VCFCertificateCSRs -domainName MGMT | ConvertTo-Json
```
This example gets a list of CSRs and displays them in JSON format

### Parameters

#### -domainName
- Name of the Domain

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
