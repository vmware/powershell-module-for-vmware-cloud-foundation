---
title: "Get-VCFHost"
weight: 3
description: >
    Retrieve a list of hosts
---

## Syntax
``` powershell
Get-VCFHost -fqdn <string> -status <string> -id <string>
```

### Parameters

| Required | Parameter | Type     |  Description                                                   |
| ---------| ----------|----------| -------------------------------------------------------------- |
| optional | fqdn      | String   | Specifies the fqdn of the ESXi host                            | 
| optional | status    | String   | Specifies the status of the ESXi host(s)                       |
| optional | id        | String   | Specifies the unique ID of the ESXi host                       |


VMware Cloud Foundation Hosts are defined by the following status:
- ASSIGNED - Hosts that are assigned to a Workload domain
- UNASSIGNED_USEABLE - Hosts that are available to be assigned to a Workload Domain
- UNASSIGNED_UNUSEABLE - Hosts that are currently not assigned to any domain and can be used for other domain tasks after completion of cleanup operation

## Examples
### Example 1
``` powershell
Get-VCFHost
```
Retrieves all hosts regardless of status

#### Example 2
``` powershell
Get-VCFHost -Status ASSIGNED
```
Retrieves all hosts with a specific status

#### Example 3
``` powershell
Get-VCFHost -id edc4f372-aab5-4906-b6d8-9b96d3113304
```
Retrieves a host by id

#### Example 4
``` powershell
Get-VCFHost -fqdn sfo01-m01-esx01.sfo.rainpole.io
```
Retrieves a host by fqdn
