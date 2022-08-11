---
title: "Get-VCFCredential"
weight: 1
description: >
    Retrieves a list of credentials
---

## Syntax
``` powershell
Get-VCFCredential -resourceName <string> -resourceType <string> -id <string>
```

### Parameters

| Required | Parameter     | Type     |  Description                                                                                                                  |
| ---------| --------------|----------| ----------------------------------------------------------------------------------------------------------------------------- |
| optional | resourceName  | String   | Specifies a credential  ID of the Application Virtual Network                                                                 |
| optional | resourceType  | String   | Specifies a credential by resource type  (BACKUP, ESXI, NSXT_EDGE, NSXT_MANAGER, PSC, VCENTER, VRA, vRLI, vROPS, vRSLCM, WSA) |
| optional | id            | String   | Specifies a credential by unique ID                                                                                           |

---
**Note**

You must have ADMIN role assigned.

---

## Examples
### Example 1
``` powershell
Get-VCFCredential
```
Retrieves a list of credentials

### Example 2
``` powershell
Get-VCFCredential -resourceType VCENTER
```
Retrieves list of credentials based on a resource type

### Example 3
``` powershell
Get-VCFCredential -resourceName sfo01-m01-esx01.sfo.rainpole.io
```
Retrieves a list credential for a specific resourceName (FQDN)

### Example 4
``` powershell
Get-VCFCredential -id 3c4acbd6-34e5-4281-ad19-a49cb7a5a275
```
Retrieves the credential using the id