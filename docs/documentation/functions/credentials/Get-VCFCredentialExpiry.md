# Get-VCFCredentialExpiry

## Synopsis

Retrieves the password expiry details of credentials.

## Syntax

```powershell
Get-VCFCredentialExpiry [[-resourceName] <String>] [[-resourceType] <String>] [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFCredentialExpiry` cmdlet retrieves the password expiry details of credentials. You can retrieve the password expiry details of credentials by resource name, resource type, or user ID.

## Examples

### Example 1

```powershell
Get-VCFCredentialExpiry
```

This example shows how to retrieve a list of all credentials with their password expiry details.

### Example 2

```powershell
Get-VCFCredentialExpiry -id 511906b0-e406-46b3-9f5d-38ece1501077
```

This example shows how to retrieve password expiry details of the credential by unique ID.

### Example 3

```powershell
Get-VCFCredentialExpiry -resourceName sfo-m01-vc01.sfo.rainpole.io
```

This example shows how to retrieve password expiry details by resource name.

### Example 4

```powershell
Get-VCFCredentialExpiry -resourceType VCENTER
```

This example shows how to retrieve a list of credentials with their password expiry details by resource type.

## Parameters

### -resourceName

Specifies the name of the resource.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -resourceType

Specifies the type of the resource. One of: VCENTER, PSC, ESXI, BACKUP, NSXT_MANAGER, NSXT_EDGE, VRSLCM, WSA, VROPS, VRLI, VRA.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id

Specifies the unique ID of the credential.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
