# Get-VCFvROPS

## Synopsis

Retrieves information about VMware Aria Operations, formerly vRealize Operations, deployment in VMware Cloud Foundation mode.

## Syntax

```powershell
Get-VCFvROPS [-domains] [<CommonParameters>]
```

## Description

The Get-VCFvROPs cmdlet retrieves information about VMware Aria Operations deployment in VMware Cloud Foundation mode.

## Examples

### Example 1

```powershell
Get-VCFvROPs
```

This example shows how to retrieve information about VMware Aria Operations deployment in VMware Cloud Foundation mode.

### Example 2

```powershell
Get-VCFvROPs -domains
```

This example shows how to retrieve information workload domains connected to VMware Aria Operations.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
