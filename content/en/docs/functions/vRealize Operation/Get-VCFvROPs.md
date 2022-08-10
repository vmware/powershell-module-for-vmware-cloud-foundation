---
title: "Get-VCFvROPS"
weight: 1
description: >
    Retrieves vRealize Operations details
---

## Syntax
``` powershell
Get-VCFvROPS -domains <switch>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                                         |
| ---------| ------------|----------| -------------------------------------------------------------------------------------------------------------------- |
| optional | domains     | Switch   | Specifies to list the Workload Domains connected                                                                     |

## Examples
### Example 1
``` powershell
Get-VCFvROPS
```
Retrieves vRealize Operations details

### Example 2
``` powershell
Get-VCFvROPS -domains
```
Retrieves a lists of all workload domains connected to vRealize Operations
