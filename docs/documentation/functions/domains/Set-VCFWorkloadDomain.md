# Set-VCFWorkloadDomain

## Synopsis

Marks a workload domain for deletion.

## Syntax

```powershell
Set-VCFWorkloadDomain [-id] <String> [<CommonParameters>]
```

## Description

The `Set-VCFWorkloadDomain` cmdlet marks a workload domain for deletion.

???+ info

    Before a workload domain can be removed it must first be marked for deletion.
    Please see [Remove-VCFWorkloadDomain](Remove-VCFWorkloadDomain.md) for more information.

## Examples

### Example 1

```powershell
Set-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
```

This example shows how to mark a workload domain for deletion.

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
