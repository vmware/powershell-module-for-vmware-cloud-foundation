# Remove-VCFWorkloadDomain

## Synopsis

Removes a workload domain.

## Syntax

```powershell
Remove-VCFWorkloadDomain [-id] <String> [<CommonParameters>]
```

## Description

The `Remove-VCFWorkloadDomain` cmdlet removes a workload domain from the SDDC Manager. You can specify the workload domain by unique ID.

???+ note

    Before a workload domain can be deleted it must first be marked for deletion.
    Please see [Set-VCFWorkloadDomain](Set-VCFWorkloadDomain.md) for more information.

## Examples

### Example 1

```powershell
Remove-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
```

This example shows how to remove a workload domain by unique ID.

## Parameters

### -id

Specifies the unique ID of the workload domain.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
