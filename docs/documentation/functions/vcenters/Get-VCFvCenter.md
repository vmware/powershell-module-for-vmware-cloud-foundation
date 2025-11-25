# Get-VCFvCenter

## Synopsis

Retrieves a list of vCenter Servers instances managed by SDDC Manager.

## Syntax

```powershell
Get-VCFvCenter [[-id] <String>] [[-domainId] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFvCenter` cmdlet retrieves a list of vCenter Servers instances managed by SDDC Manager.

## Examples

### Example 1

```powershell
Get-VCFvCenter
```

This example shows how to retrieve a list of all vCenter Server instances managed by SDDC Manager.

### Example 2

```powershell
Get-VCFvCenter -id d189a789-dbf2-46c0-a2de-107cde9f7d24
```

This example shows how to return the details of a vCenter Server instance managed by SDDC Manager by its unique ID.

### Example 3

```powershell
Get-VCFvCenter -domain 1a6291f2-ed54-4088-910f-ead57b9f9902
```

This example shows how to return the details of a vCenter Server instance managed by SDDC Manager by unique ID of its workload domain.

### Example 4

```powershell
Get-VCFvCenter | select fqdn
```

This example shows how to retrieve a list of all vCenter Servers managed by SDDC Manager and display only their FQDN.

## Parameters

### -id

Specifies the unique ID of the vCenter Server instance.

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

### -domainId

Specifies the unique ID of the workload domain.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
