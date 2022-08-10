---
title: "Get-VCFWorkloadDomain"
weight: 1
description: >
    Retrieve a list of Workload Domains
---

## Syntax
``` powershell
Get-VCFWorkloadDomain -name <string> -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                        |
| ---------| -----------|----------| ------------------------------------------------------------------- |
| optional | name       | String   | Specifies the name of the Workload Domain                           |
| optional | id         | String   | Specifies the unique ID of the Workload Domain                      |
| optional | endpoints  | Switch   | Specifies the unique ID of the Workload Domain                      |

## Examples
### Example 1
``` powershell
Get-VCFWorkloadDomain
```
Retrieves a list of all Workload Domains

### Example 2
``` powershell
Get-VCFWorkloadDomain -name WLD01
```
Retrieves a Workload Domain by name

### Example 3
``` powershell
Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
```
Retrieves a Workload Domain by id

### Example 4
``` powershell
Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2 -endpoints | ConvertTo-Json
```
Retrieves the endpoints of a Workload Domain by its id and displays the output in Json format
