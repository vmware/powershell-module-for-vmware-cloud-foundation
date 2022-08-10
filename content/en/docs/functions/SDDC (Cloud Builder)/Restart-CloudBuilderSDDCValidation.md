---
title: "Restart-CloudBuilderSDDCValidation"
weight: 4
description: >
    Retry a failed Management Domain validation task
---

## Syntax
``` powershell
Restart-CloudBuilderSDDCValidation -id <string>
```

| Required | Parameter | Type     |  Description                                                                                                    |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------------------------- |
| required | id        | String   | Specifies the unique ID of the Management Domain validation task                                                |

## Examples
### Example 1
``` powershell
Restart-CloudBuilderSDDCValidation -id bedf19f8-9dfe-4c60-aae4-bca986a65a31
```
Retries a failed Management Domain validation task by unique ID
