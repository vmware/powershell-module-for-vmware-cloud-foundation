---
title: "Restart-VCFCredentialTask"
weight: 3
description: >
    Retry a failed password rotation or update task
---

## Syntax
``` powershell
Restart-VCFCredentialTask -id <string> -json <json_file>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| required | json       | String   | Specifies the JSON specification file to be used               | 
| required | id         | String   | Specifies the unique ID of task                                |

## Examples
### Example 1
``` powershell
Restart-VCFCredentialTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d -json .\Credential\updateCredentialSpec.json
```
Retry a password update of a resource using the json spec