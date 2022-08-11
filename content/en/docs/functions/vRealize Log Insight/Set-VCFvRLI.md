---
title: "Set-VCFvRLI"
weight: 2
description: >
    Connect or disconnect Workload Domains to vRealize Log Insight
---

## Syntax
``` powershell
Set-VCFvRLI -domainId <string> -status <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                                         |
| ---------| ------------|----------| -------------------------------------------------------------------------------------------------------------------- |
| required | domainId    | String   | Specifies the unique ID of the VI Workload Domain                                                                    |
| required | status      | String   | Specifies the status (Accepted: ENABLED, DISABLED)                                                                   |

## Examples
### Example 1
``` powershell
Set-VCFvRLI -domainId 44d23b12-76b6-4453-95f6-1dcaa837081f -status ENABLED
```
Connects a VI Workload Domain to vRealize Log Insight

### Example 2
``` powershell
Set-VCFvRLI -domainId 44d23b12-76b6-4453-95f6-1dcaa837081f -status DISABLED
```
Disconnects a VI Workload Domain from vRealize Log Insight
