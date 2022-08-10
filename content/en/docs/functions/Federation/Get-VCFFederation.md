---
title: "Get-VCFFederation"
weight: 1
description: >
    Retrieve information on an existing Federation (Multi-Instance Management)
---

{{% alert title="Warning" color="warning" %}} The Federation (Multi-Instance Management) feature of VMware Cloud Foundation has been depreciated in VMware Cloud Foundation v4.4.0 and later. {{% /alert %}}

## Syntax
``` powershell
Get-VCFFederation
```

## Examples
### Example 1
``` powershell 
Get-VCFFederation
```
Retrieves all details concerning the Federation (Multi-Instance Management)

### Example 2
``` powershell
Get-VCFFederation | ConvertTo-Json
```
Retrieves all details concerning the Federation (Multi-Instance Management) and outputs them in json format
