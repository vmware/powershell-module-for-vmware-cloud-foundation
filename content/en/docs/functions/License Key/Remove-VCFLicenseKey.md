---
title: "Remove-VCFLicenseKey"
weight: 3
description: >
    Deletes a License key
---

## Syntax
``` powershell
Remove-VCFLicenseKey -key <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                            |
| ---------| ------------|----------| ------------------------------------------------------------------------------------------------------- |
| required | key         | String   | Specifies the license key                                                                               |

## Examples
### Example 1
``` powershell
Remove-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
```
Deletes a License Key
