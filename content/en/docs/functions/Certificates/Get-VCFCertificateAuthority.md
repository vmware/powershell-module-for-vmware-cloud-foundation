---
title: "Get-VCFCertificateAuthority"
weight: 2
description: >
    Retrieve the certificate authority information
---

## Syntax
``` powershell
Get-VCFCertificateAuthority -caType <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                               |
| ---------| ------------|----------| -------------------------------------------------------------------------- |
| optional | caType      | String   | Specifies the Certificate Authority type, supports Microsoft and OpenSSL   | 


## Examples
### Example 1
``` powershell
Get-VCFCertificateAuthority
```
Retrieves the certificate authority configuration

### Example 2
``` powershell
Get-VCFCertificateAuthority | ConvertTo-Json
```
Retrieves the certificate authority configuration and outputs to Json format

### Example 3
``` powershell
Get-VCFCertificateAuthority -caType Microsoft
```
Retrieves the certificate authority configuration for a Microsoft Certificate Authority