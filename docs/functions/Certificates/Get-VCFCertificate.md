# Get-VCFCertificate

### Synopsis
Get latest generated certificate(s) in a domain

### Syntax
```
Get-VCFCertificate -domainName <string>
```

### Description
Get latest generated certificate(s) in a domain

### Examples
#### Example 1
```
Get-VCFCertificate -domainName MGMT
```
This example gets a list of certificates that have been generated

#### Example 2
```
Get-VCFCertificate -domainName MGMT | ConvertTo-Json
```
This example gets a list of certificates and displays them in JSON format

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
