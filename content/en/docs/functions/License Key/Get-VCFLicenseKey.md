---
title: "Get-VCFLicenseKey"
weight: 1
description: >
    Retrieves a list of License keys
---

## Syntax
``` powershell
Get-VCFLicenseKey -key <string> -productType <list> -status <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                                         |
| ---------| ------------|----------| -------------------------------------------------------------------------------------------------------------------- |
| optional | key         | String   | Specifies the license key                                                                                            |
| optional | productType | String   | Specifies the license key for a product (Accepted: VCENTER, VSAN, ESXI, WCP, NSXT, NSXV, SDDC_MANAGER, HORIZON_VIEW) |
| optional | status      | String   | Specifies the license key by status (Accepted: EXPIRED, ACTIVE, NEVER_EXPIRES)                                       |


## Examples
### Example 1
``` powershell
Get-VCFLicenseKey
```
Retrieves a list of all License keys

### Example 2
``` powershell
Get-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
```
Retrieves the specified License key

### Example 3
``` powershell
Get-VCFLicenseKey -productType VCENTER
```
Retrieves a list of License Key by product type

### Example 4
``` powershell
Get-VCFLicenseKey -status EXPIRED
```
Retrieves a list of License Keys by status
