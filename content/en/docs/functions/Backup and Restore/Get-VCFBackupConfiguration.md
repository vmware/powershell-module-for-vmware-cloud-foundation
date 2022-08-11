---
title: "Get-VCFBackupConfiguration"
weight: 1
description: >
    Retrieves the current backup configuration details from SDDC Manager
---

### Syntax
``` powershell
Get-VCFBackupConfiguration
```

## Examples
### Example 1
``` powershell
Get-VCFBackupConfiguration    
```
Retrieves the backup configuration

### Example 2
``` powershell
Get-VCFBackupConfiguration | ConvertTo-Json  
```
Retrieves the backup configuration and outputs it in json format