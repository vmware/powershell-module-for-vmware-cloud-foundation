# Get-VCFVrops

## Alias

`Get-VCFAriaOperations`

## Synopsis

Retrieves information about Aria Operations deployment in VMware Cloud Foundation mode.

## Syntax

```powershell
Get-VCFVrops [-domains] [<CommonParameters>]
```

## Description

The `Get-VCFVrops` cmdlet retrieves information about Aria Operations deployment in VMware Cloud Foundation mode.

## Examples

### Example 1

```powershell
Get-VCFVrops
```

This example shows how to retrieve information about Aria Operations deployment in VMware Cloud Foundation mode.

### Example 2

```powershell
Get-VCFVrops -domains
```

This example shows how to retrieve information workload domains connected to Aria Operations.

## Parameters

### -domains

Specifies to list the connected workload domains.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
