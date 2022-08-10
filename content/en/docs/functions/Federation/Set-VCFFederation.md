---
title: "Set-VCFFederation"
weight: 2
description: >
    Creates Federation (Multi-Instance Management)
---

{{% alert title="Warning" color="warning" %}} The Federation (Multi-Instance Management) feature of VMware Cloud Foundation has been depreciated in VMware Cloud Foundation v4.4.0 and later. {{% /alert %}}

### Syntax
``` powershell
Set-VCFFederation -json <string> or <file>
```

## Examples
### Example 1
``` powershell
Set-VCFFederation -json $jsonSpec
```
Create Federation (Multi-Instance Management) using a variable

#### Example 2
``` powershell
Set-VCFFederation -json (Get-Content -Raw .\federationSpec.json)
```
Create Federation (Multi-Instance Management) using a JSON file
