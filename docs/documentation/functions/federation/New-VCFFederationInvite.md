# New-VCFFederationInvite

## Synopsis

Invites a member to join an existing federation.

## Syntax

```powershell
New-VCFFederationInvite [-inviteeFqdn] <String> [-inviteeRole] <String> [<CommonParameters>]
```

## Description

The `New-VCFFederationInvite` cmdlet invites a member to join an existing federation controller.

???+ warning

    This API is was deprecated in VMware Cloud Foundation 4.3.0 and removed in VMware Cloud Foundation 4.4.0.

## Examples

### Example 1

```powershell
New-VCFFederationInvite -inviteeFqdn lax-vcf01.lax.rainpole.io -inviteeRole MEMBER
```

This example shows how to invite a member to join an existing federation controller.

## Parameters

### -inviteeFqdn

Specifies the fully qualified domain name (FQDN) of the member to invite to join the federation.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -inviteeRole

Specifies the role to ba assigned. One of: MEMBER, CONTROLLER.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
