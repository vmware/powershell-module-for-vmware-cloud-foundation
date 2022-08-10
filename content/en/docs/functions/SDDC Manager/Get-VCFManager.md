---
title: "Get-VCFManager"
weight: 1
description: >
    Retrieves a list of SDDC Managers
---

## Syntax
``` powershell
Get-VCFManager -id <string> -domainId <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                                         |
| ---------| ------------|----------| -------------------------------------------------------------------------------------------------------------------- |
| optional | id          | String   | Specifies the unique ID of the SDDC Manager                                                                          |
| optional | domainId    | String   | Specifies the unique ID of a workload domain                                                                         |

## Examples
### Example 1
``` powershell
Get-VCFManager
```
Retrieves a list of all SDDC Managers  

### Example 2
``` powershell
Get-VCFManager -id 60d6b676-47ae-4286-b4fd-287a888fb2d0
```
Retrieves specific SDDC Manager based on the unique ID 

### Example 2
``` powershell
Get-VCFManager -domainId 1a6291f2-ed54-4088-910f-ead57b9f9902
```
Retrieves specific SDDC Manager based on a workload domains unique ID
