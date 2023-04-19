---
title: "New-VCFPersonality"
weight: 2
description: >
    Adds a new vSphere Lifecycle Manager personality/image in the SDDC Manager inventory from an existing vLCM image based cluster
---

## Syntax
``` powershell
New-VCFPersonality -name "vSphere 8.0U1" -vCenterId 6c7c3aaa-79cb-42fd-ade3-353f682cb1dc -clusterId "domain-c44"
```

### Parameters

| Required | Parameter   | Type     |  Description                                                                                                          |
| ---------| ------------|----------| ----------------------------------------------------------------------------------------------------------------------|
| required | name        | String   | Specifies the image name                                                                                              |
| required | vCenterId   | String   | Specifies the VCF vCenter ID from which the cluster image will be imported                                            |
| required | clusterId   | String   | Specifies the vSphere cluster ID from which the image will be imported. Can be vSphere Moref ID or VCF cluster ID     |

## Examples
### Example 1
``` powershell
New-VCFPersonality -name "vSphere 8.0U1" -vCenterId 6c7c3aaa-79cb-42fd-ade3-353f682cb1dc -clusterId "domain-c44"
```
Adds a new vSphere Lifecycle Manager personality/image in the SDDC Manager inventory from an existing vLCM image based cluster
