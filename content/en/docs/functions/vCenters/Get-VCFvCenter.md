---
title: "Get-VCFvCenter"
weight: 1
description: >
    Retrieves a list of vCenter Servers
---

## Syntax
``` powershell
Get-VCFvCenter -id <string> -domainId <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                                         |
| ---------| ------------|----------| -------------------------------------------------------------------------------------------------------------------- |
| optional | id          | String   | Specifies the unique ID of the vCenter Server                                                                        |
| optional | domainId    | String   | Specifies the unique ID of a workload domain                                                                         |

## Examples
### Example 1
``` powershell
Get-VCFvCenter
```
Retrieves a list of all vCenter Servers

### Example 2
``` powershell
Get-VCFvCenter -id d189a789-dbf2-46c0-a2de-107cde9f7d24
```
Retrieves the details for a specific vCenter Server based on the unique ID

### Example 3
``` powershell
Get-VCFvCenter -domain 1a6291f2-ed54-4088-910f-ead57b9f9902
```
Retrieves the details for a specific vCenter Server based on a workload domains unique ID

### Example 4
``` powershell
Get-VCFvCenter | Select-Object fqdn
```
Retrieves a list of all vCenter Servers but only return the fqdn
