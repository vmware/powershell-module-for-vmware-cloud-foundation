# Get-VCFCertificate

### Synopsis
Get latest generated certificate(s) in a domain

### Syntax
```
Get-VCFCertificate -domainName <string> -resources
```

### Description
The Get-VCFCertificate cmdlet gets the latest generated certificate(s) in a domain

### Examples
#### Example 1
```
Get-VCFCertificate -domainName sfo-m01
```
This example gets a list of certificates that have been generated

#### Example 2
```
Get-VCFCertificate -domainName sfo-m01 | ConvertTo-Json
```
This example gets a list of certificates and displays them in JSON format

#### Example 3
```
Get-VCFCertificate -domainName sfo-m01 | Select issuedTo
```
This example gets a list of endpoint names where certificates have been issued

#### Example 4
```
Get-VCFCertificate -domainName sfo-m01 -resources
```
This example gets the certificates of all resources in the domain

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
