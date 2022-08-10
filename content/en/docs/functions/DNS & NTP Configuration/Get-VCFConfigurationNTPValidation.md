---
title: "Get-VCFConfigurationNTPValidation"
weight: 4
description: >
    Retrieve the status of the validation of the NTP configuration
---

## Syntax
``` powershell
Get-VCFConfigurationNTPValidation -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| required | id         | String   | Specifies the unique ID of the validation                      |


## Examples
### Example 1
``` powershell
Get-VCFConfigurationNTPValidation -id a749fcc5-fb61-2d05-aa40-9c7686164fc2
```
Retrieve the status of the validation of the NTP Configuration