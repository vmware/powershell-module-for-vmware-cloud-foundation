---
title: "Get-VCFCertificateCSR"
weight: 3
description: >
    Retrieve the latest generated certificate signing request(s) (CSR) for a domain
---


## Syntax
``` powershell
Get-VCFCertificateCSRs -domainName <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                   |
| ---------| ------------|----------| -------------------------------------------------------------- |
| required | domainName  | String   | Specifies the name of the domain                               | 

## Examples
### Example 1
``` powershell
Get-VCFCertificateCSRs -domainName MGMT
```
Retrieve a list of certificate signing request(s) (CSR) for a domain

### Example 2
``` powershell
Get-VCFCertificateCSRs -domainName MGMT | ConvertTo-Json
```
Retrieve a list of certificate signing request(s) (CSR) for a domain and displays them in JSON format