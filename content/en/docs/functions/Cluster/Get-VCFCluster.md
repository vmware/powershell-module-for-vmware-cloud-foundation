---
title: "Get-VCFCluster"
weight: 1
description: >
    Retrieves a list of clusters
---

## Syntax
``` powershell
Get-VCFWorkloadDomain -name <string> -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                        |
| ---------| -----------|----------| ------------------------------------------------------------------- |
| optional | name       | String   | Specifies the name of the Cluster                                   |
| optional | id         | String   | Specifies the unique ID of the Cluster                              |


## Examples
### Example 1
``` powershell
Get-VCFCluster
```
Retrieves a list of all clusters

### Example 2
``` powershell
Get-VCFCluster -name wld01-cl01
```
Retrieves a cluster by name

### Example 3
``` powershell
Get-VCFCluster -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
```
Retrieves a cluster by id`