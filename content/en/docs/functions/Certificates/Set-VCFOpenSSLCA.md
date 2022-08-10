---
title: "Set-VCFOpenSSLCA"
weight: 9
description: >
    Configures OpenSSL Certificate Authority integration
---

## Syntax
``` powershell
Set-VCFOpenSSLCA -commonName <string> -organization <string> -organizationUnit <string> -locality <string> -state <string> -country <string>
```

### Parameters

| Required | Parameter        | Type     |  Description                                                                               |
| ---------| -----------------|----------| ------------------------------------------------------------------------------------------ |
| required | commonName       | String   | Specifies the common name for the OpenSSL Certificate Authority                            |
| required | organization     | String   | Specifies the organization for the OpenSSL Certificate Authority                           |
| required | organizationUnit | String   | Specifies the organization unit for the OpenSSL Certificate Authority                      |
| required | locality         | String   | Specifies the locality for the OpenSSL Certificate Authority                               |
| required | state            | String   | Specifies the state for the OpenSSL Certificate Authority                                  |
| required | country          | String   | Specifies the country for the OpenSSL Certificate Authority                                |

## Examples
### Example 1
``` powershell
Set-VCFOpenSSLCA -commonName sddcManager -organization Rainpole -organizationUnit Support -locality "Palo Alto" -state CA -country US
```
Configure OpenSSL Certificate Authority integration with SDDC Manager