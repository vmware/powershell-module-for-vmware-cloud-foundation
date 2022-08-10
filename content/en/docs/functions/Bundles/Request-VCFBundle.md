---
title: "Request-VCFBundle"
weight: 2
description: >
    Requests the download of bundle from depot
---

## Syntax
``` powershell
Request-VCFBundle -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| optional | id         | String   | Specifies the unique ID of the bundle                          |

## Examples
### Example 1
``` powershell
Request-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
```
Requests the immediate download of a bundle based on its id