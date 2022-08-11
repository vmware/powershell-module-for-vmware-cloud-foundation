---
title: "Get-CloudBuilderSDDCValidation"
weight: 2
description: >
    Retrieves a list of Management Domain validations tasks
---

## Syntax
``` powershell
Get-CloudBuilderSDDCValidation -id <string>

```
### Parameters

| Required | Parameter | Type     |  Description                                                                                                    |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------------------------- |
| optional | id        | String   | Specifies the unique ID of the Management Domain validation task                                                |


## Examples
### Example 1
``` powershell
Get-CloudBuilderSDDCValidation
```
Retrieves a list of all Management Domain validations tasks

### Example 2
``` powershell
Get-CloudBuilderSDDCValidation -id 1ff80635-b878-441a-9e23-9369e1f6e5a3
```
Retrieves a Management Domain validations by unique ID
