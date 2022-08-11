---
title: "Get-VCFNsxtCluster"
weight: 1
description: >
    Retrieves a list of NSX-T Clusters
---

## Syntax
``` powershell
Get-VCFNsxtCluster -id <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                                         |
| ---------| ------------|----------| -------------------------------------------------------------------------------------------------------------------- |
| optional | id          | String   | Specifies the unique ID of the NSX-T Cluster                                                                         |

## Examples
### Example 1
``` powershell
Get-VCFNsxtCluster
```
Retrieves a list of all NSX-T Clusters

### Example 2
``` powershell
Get-VCFNsxtCluster -id d189a789-dbf2-46c0-a2de-107cde9f7d24
```
Retrieves the details for a specific NSX-T Cluster using the unique ID

### Example 3
``` powershell
Get-VCFNsxtCluster | Select-Object vipFqdn		
```
Retrieves a list of all NSX-T Clusters returning only the vipFqdn
