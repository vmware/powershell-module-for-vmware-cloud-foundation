---
title: "Get-VCFPersonality"
weight: 1
description: >
    Retrieves vSphere Lifecycle Manager personalities
---

### Syntax
``` powershell
Get-VCFPersonality -id <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                                         |
| ---------| ------------|----------| -------------------------------------------------------------------------------------------------------------------- |
| optional | id          | String   | Specifies the unique ID of the vSphere Lifecycle Manager personality                                                 |

## Examples
### Example 1
``` powershell
Get-VCFPersonality
```
Retrieves a list of all the vSphere Lifecycle Manager personalities

### Example 2
``` powershell
Get-VCFPersonality -id b4e3b2c4-31e8-4816-b1c5-801e848bef09
```
Retrieves a vSphere Lifecycle Manager personality by unique ID
