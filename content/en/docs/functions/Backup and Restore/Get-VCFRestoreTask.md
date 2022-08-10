---
title: "Get-VCFRestoreTask"
weight: 2
description: >
    Retrieves the status of the restore task
---

## Syntax
``` powershell
Get-VCFRestoreTask -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| optional | id         | String   | Specifies the unique ID of the restore task                    |

## Examples
### Example 1
``` powershell
Get-VCFRestoreTask -id a5788c2d-3126-4c8f-bedf-c6b812c4a753    
```
Retrieve the status of the restore task by id 