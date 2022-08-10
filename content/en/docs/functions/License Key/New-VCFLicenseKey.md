---
title: "New-VCFLicenseKey"
weight: 2
description: >
    Adds a new License key
---

## Syntax
``` powershell
New-VCFLicenseKey -key <string> -productType <string> -description <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                            |
| ---------| ------------|----------| ------------------------------------------------------------------------------------------------------- |
| required | key         | String   | Specifies the license key                                                                               |
| required | productType | String   | Specifies the product type (Accepted: VCENTER, VSAN, ESXI, WCP, NSXT, NSXV, SDDC_MANAGER, HORIZON_VIEW) |
| required | status      | String   | Specifies the description for the license                                                               |

## Examples
### Example 1
``` powershell
New-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA" -productType VCENTER -description "vCenter License"
```
Adds a new vCenter Server License key to SDDC Manager
