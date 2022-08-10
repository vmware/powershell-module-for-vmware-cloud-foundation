---
title: "New-VCFFederationInvite"
weight: 1
description: >
    Creates a new invitation for a member to join Federation (Multi-Instance Management)
---

{{% alert title="Warning" color="warning" %}} The Federation (Multi-Instance Management) feature of VMware Cloud Foundation has been depreciated in VMware Cloud Foundation v4.4.0 and later. {{% /alert %}}

## Syntax
``` powershell
New-VCFFederationInvite -inviteeFqdn <string> -inviteeRole <string>
```

### Parameters

| Required | Parameter    | Type     |  Description                                                                 |
| ---------| -------------|----------| ---------------------------------------------------------------------------- |
| required | inviteeFqdn  | String   | Specifies the fqdn of the system to invite                                   | 
| required | inviteeRole  | String   | Specifies the role to ba assigned (Accepts: MEMBER / CONTROLLER)             | 

## Examples
### Example 1
``` powershell
New-VCFFederationInvite -inviteeFqdn lax-vcf01.lax.rainpole.io -inviteeRole MEMBER
```
This example demonstrates how to create an invitation for a specified VCF Manager from the Federation controller.

### Parameters

#### -inviteeFqdn
FQDN for the system you want to invite

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -inviteeRole
Role of the system

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: CONTROLLER, MEMBER, MANAGER
```

### Notes

### Related Links
