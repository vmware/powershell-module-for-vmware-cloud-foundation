---
title: "Get-VCFConfigurationDNSValidation"
weight: 2
description: >
    Retrieve the status of the validation of the DNS configuration
---

## Syntax
``` powershell
Get-VCFConfigurationDNSValidation -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| required | id         | String   | Specifies the unique ID of the validation                      |


## Examples
### Example 1
``` powershell
Get-VCFConfigurationDNSValidation -id d729fcc5-fb61-2d05-aa40-9c7686163fa1
```
Retrieve the status of the validation of the DNS Configuration