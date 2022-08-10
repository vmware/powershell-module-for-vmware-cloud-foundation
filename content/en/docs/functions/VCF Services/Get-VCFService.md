---
title: "Get-VCFService"
weight: 1
description: >
    Retrieve list of running VMware Cloud Foundation Services
---

## Syntax
``` powershell
Get-VCFService -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                        |
| ---------| -----------|----------| ------------------------------------------------------------------- |
| optional | id         | String   | Specifics the unique ID of the VMware Cloud Foundation service      |

## Examples
### Example 1
``` powershell
Get-VCFService
```
Retrieve a list of services running on SDDC Manager

#### Example 2
``` powershell
Get-VCFService -id 4e416419-fb82-409c-ae37-32a60ba2cf88
```
Retrieve the details for a specific service running on SDDC Manager based on the id