---
title: "Remove-VCFWorkloadDomain"
weight: 1
description: >
    Deletes a Workload Domains
---

## Syntax
``` powershell
Remove-VCFWorkloadDomain -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| required | id         | String   | Specifies the unique ID of the Workload Domain                 |

{{% alert title="Note" color="warning" %}} Before a Workload Domain can be deleted it must first be marked for deletion (see [Set-VCFWorkloadDomain](Set-VCFWorkloadDomain)). {{% /alert %}}

## Examples
### Example 1
``` powershell
Remove-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
```
Deletes a workload domain
