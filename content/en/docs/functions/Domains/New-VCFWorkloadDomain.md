---
title: "New-VCFWorkloadDomain"
weight: 1
description: >
    Creates a Workload Domains
---

## Syntax
``` powershell
New-VCFWorkloadDomain -json <json-file>
```

### Parameters

| Required | Parameter | Type     |  Description                                                   |
| ---------| ----------|----------| -------------------------------------------------------------- |
| required | json      | String   | Specifies the JSON specification file to be used               | 

## Examples
### Example 1
``` powershell
New-VCFWorkloadDomain -json .\WorkloadDomain\workloadDomainSpec.json
```
Creates a Workload Domain from a json spec
