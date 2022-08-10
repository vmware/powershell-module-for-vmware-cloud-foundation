---
title: "Get-VCFFederationTask"
weight: 1
description: >
    Creates a new invitation for a member to join Federation (Multi-Instance Management)
---

{{% alert title="Warning" color="warning" %}} The Federation (Multi-Instance Management) feature of VMware Cloud Foundation has been depreciated in VMware Cloud Foundation v4.4.0 and later. {{% /alert %}}

## Syntax
``` powershell
Get-VCFFederationTask -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                                 |
| ---------| -----------|----------| ---------------------------------------------------------------------------- |
| required | id         | String   | Specifies the unique ID of the federation task                               |

## Examples
### Example 1
``` powershell
Get-VCFFederationTask -id f6f38f6b-da0c-4ef9-9228-9330f3d30279
```
Retrieves a federation tasks by id
