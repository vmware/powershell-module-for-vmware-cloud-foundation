---
title: "Get-VCFClusterValidation"
weight: 2
description: >
    Retrieves the status of the validations for cluster deployment
---

## Syntax
``` powershell
Get-VCFClusterValidation -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| optional | id         | String   | Specifies the unique ID of the Cluster                         |

## Examples
### Example 1
``` powershell
Get-VCFClusterValidation -id 001235d8-3e40-4a5a-8a89-09985dac1434
```
Retrieves the cluster validation task based on the id