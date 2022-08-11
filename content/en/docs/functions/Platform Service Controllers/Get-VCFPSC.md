---
title: "Get-VCFPSC"
weight: 1
description: >
    Retrieves a list of Platform Services Controllers
---

## Syntax
``` powershell
Get-VCFPSC -id <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                                         |
| ---------| ------------|----------| -------------------------------------------------------------------------------------------------------------------- |
| optional | id          | String   | Specifies the unique ID of the Platform Services Controller                                                          |

## Examples
### Example 1
``` powershell
Get-VCFPSC
```
Retrieves a list of all Platform Services Controllers

#### Example 2
``` powershell
Get-VCFPSC -id f6f38f6b-da0c-4ef9-9228-9330f3d30279
```
Retrieves a Platform Services Controller by unique id
