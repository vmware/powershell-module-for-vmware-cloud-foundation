# Get-VCFCredential

## Synopsis

Retrieves a list of credentials.

## Syntax

```powershell
Get-VCFCredential [[-resourceName] <String>] [[-resourceType] <String>] [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFCredential` cmdlet retrieves a list of credentials from the SDDC Manager database. The cmdlet can be used to retrieve all credentials, or a specific credential by resourceName, resourceType, or id.

???+ info

    Supported resource types include: VCENTER, ESXI, NSXT_MANAGER, NSXT_EDGE, BACKUP

???+ note

    If you are requesting credentials by resource type and the resource name parameter
    is also provided, it will be ignored. The resource name parameter is only used when
    requesting credentials by resource name.

???+ note

    The authenticated user must have the the *ADMIN* role in SDDC Manager to run this cmdlet.

## Examples

### Example 1

```powershell
Get-VCFCredential
```

This example shows how to retrieve a list of credentials.

### Example 2

```powershell
Get-VCFCredential -resourceType VCENTER
```

This example shows how to retrieve a list of credentials for a specific `resourceType`.

### Example 3

```powershell
Get-VCFCredential -resourceName sfo01-m01-esx01.sfo.rainpole.io
```

This example shows how to retrieve the credential for a specific `resourceName` (FQDN).

### Example 4

```powershell
Get-VCFCredential -id 3c4acbd6-34e5-4281-ad19-a49cb7a5a275
```

This example shows how to retrieve the credential using the unique ID of the credential.

## Parameters

### -resourceName

Specifies the resource name of the credential.

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

Specifies the resource type of the credential. One of: VCENTER, ESXI, NSXT_MANAGER, NSXT_EDGE, BACKUP.

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
