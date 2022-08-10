---
title: "Get-CloudBuilderSDDC"
weight: 1
description: >
    Retrieves a list of Management Domain deployment tasks
---

## Syntax
``` powershell
Get-CloudBuilderSDDC -id <string>
```

### Parameters

| Required | Parameter | Type     |  Description                                                                                                    |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------------------------- |
| optional | id        | String   | Specifies the unique ID of the Management Domain deployment task                                                |

## Examples
### Example 1
``` powershell
Get-CloudBuilderSDDC
```
Retrieves a list of all Management Domain deployment tasks

### Example 2
``` powershell
Get-CloudBuilderSDDC -id 51cc2d90-13b9-4b62-b443-c1d7c3be0c23
```
Retrieves a Management Domain deployment task by unique ID
