---
title: "Get-VCFEdgeCluster"
weight: 1
description: >
    Retrieves a list of NSX-T Edge Clusters
---

## Syntax
``` powershell
Get-VCFEdgeCluster -id <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                                         |
| ---------| ------------|----------| -------------------------------------------------------------------------------------------------------------------- |
| optional | id          | String   | Specifies the unique ID of the NSX-T Edge Cluster                                                                    |


## Examples
### Example 1
``` powershell
Get-VCFEdgeCluster
```
Retrieves a list of all NSX-T Edge Clusters

### Example 2
``` powershell
Get-VCFEdgeCluster -id f6f38f6b-da0c-4ef9-9228-9330f3d30279
```
Retrieves an NSX-T Edge Cluster by unique id

### Example 3
``` powershell
Get-VCFEdgeCluster | Select-Object name, @{Name="vipFqdn"; Expression={ $_.nsxtCluster.vipFqdn}}
```
Retrieves a list of all NSX-T Edge Clusters returning only the NSX-T Edge node names and NSX-T Cluster vipFqdn