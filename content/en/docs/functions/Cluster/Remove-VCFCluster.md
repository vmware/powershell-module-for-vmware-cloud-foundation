---
title: "Remove-VCFCluster"
weight: 4
description: >
    Deletes a cluster from a Workload Domain
---

## Syntax
``` powershell
Remove-VCFCluster -id <string>
```

## Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| optional | id         | String   | Specifies the unique ID of the Cluster     |

---
**Note**

Before a cluster can be deleted it must first be marked for deletion. See [Set-VCFCluster](/docs/functions/cluster/set-vcfcluster)

---

## Examples
### Example 1
``` powershell
Remove-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1
```
Deletes a cluster based on the id