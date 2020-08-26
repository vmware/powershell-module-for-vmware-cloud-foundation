# New-VCFFederationInvite

### Synopsis
Invite new member to VCF Federation

### Syntax
```
New-VCFFederationInvite
```

### Description
The New-VCFFederationInvite cmdlet creates a new invitation for a member to join the existing VCF Federation.

### Examples
#### Example 1
```
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
