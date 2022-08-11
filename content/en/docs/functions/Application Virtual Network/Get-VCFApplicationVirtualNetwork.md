---
title: "Get-VCFApplicationVirtualNetwork"
weight: 2
description: >
    Retrieves Application Virtual Networks (AVN) from SDDC Manager
---

## Syntax
``` powershell
Get-VCFApplicationVirtualNetwork -regionType <string> -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                                                                    |
| ---------| -----------|----------| --------------------------------------------------------------------------------------------------------------- |
| optional | id         | String   | Specifies the unique ID of the Application Virtual Network                                                      |
| optional | regionType | String   | Specifies the region, supports REGION_A, REGION_B, X_REGION                                                     |

## Examples
### Example 1
``` powershell
Get-VCFApplicationVirtualNetwork
```
Retrieve a list of Application Virtual Networks

#### Example 2
``` powershell
Get-VCFApplicationVirtualNetwork -id 577e6262-73a9-4825-bdb9-4341753639ce
```
Retrieve the details of the Application Virtual Networks using the id

### Example 3
``` powershell
Get-VCFApplicationVirtualNetwork -regionType REGION_A
```
Retrieve the details of the Application Virtual Network with a regionType of REGION_A
