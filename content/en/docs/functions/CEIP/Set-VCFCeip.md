---
title: "Set-VCFCeip"
weight: 1
description: >
    Sets the Customer Experience Improvement Program (CEIP) status (Enabled/Disabled) of the connected SDDC Manager
---

## Syntax
``` powershell
Set-VCFCeip -ceipSetting <string>
```

### Parameters

| Required | Parameter   | Type     |  Description                                                     |
| ---------| ------------|----------| ---------------------------------------------------------------- |
| required | ceipSetting | String   | Specifies the configuration of the CEIP, supports ENABLE/DISABLE | 


## Examples
### Example 1
``` powershell
Set-VCFCeip -ceipSetting DISABLE    
```
Disables Customer Experience Improvement Program (CEIP) for SDDC Manager, vCenter Server, vSAN and NSX Manager

### Example 2
```
Set-VCFCeip -ceipSetting ENABLE    
```
Enables Customer Experience Improvement Program (CEIP) for SDDC Manager, vCenter Server, vSAN and NSX Manager