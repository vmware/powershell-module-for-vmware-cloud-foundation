---
title: "Remove-VCFCertificateAuthority"
weight: 4
description: >
    Removes the certificate authority configuration
---

## Syntax
``` powershell
Remove-VCFCertificateAuthority -caType <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                               |
| ---------| ------------|----------| -------------------------------------------------------------------------- |
| optional | caType      | String   | Specifies the Certificate Authority type, supports Microsoft and OpenSSL   | 

## Examples
### Example 1
``` powershell
Remove-VCFCertificateAuthority -caType Microsoft
```
Removes the Microsoft Certificate Authority configuration from SDDC Manager