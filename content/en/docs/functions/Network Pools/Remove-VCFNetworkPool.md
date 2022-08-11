---
title: "Remove-VCFNetworkPool"
weight: 5
description: >
    Removes a Network Pool
---

## Syntax
``` powershell
Remove-VCFNetworkPool -id <string>
```

### Parameters

| Required | Parameter | Type     |  Description                                                                                                    |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------------------------- |
| required | id        | String   | Specifies the unique ID of the network pool                                                                     |

## Examples
### Example 1
``` powershell
Remove-VCFNetworkPool -id 7ee7c7d2-5251-4bc9-9f91-4ee8d911511f
```
Removes a Network Pool by unique id
