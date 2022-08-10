---
title: "Stop-VCFCredentialTask"
weight: 5
description: >
    Cancels a failed password update or rotation task
---

## Syntax
``` powershell
Stop-VCFCredentialTask -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| required | id         | String   | Specifies the unique ID of the credential task                 |

## Examples
### Example 1
```powershell
Stop-VCFCredentialTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d
```
Cancels the failed password update or rotation task