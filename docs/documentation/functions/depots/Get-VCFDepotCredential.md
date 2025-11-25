# Get-VCFDepotCredential

## Synopsis

Retrieves the configurations for the depot configured in the SDDC Manager instance.

## Syntax

```powershell
Get-VCFDepotCredential [-vxrail] [<CommonParameters>]
```

## Description

The `Get-VCFDepotCredential` cmdlet retrieves the configurations for the depot configured in the SDDC Manager instance.

## Examples

### Example 1

```powershell
Get-VCFDepotCredential
```

This example shows how to retrieve the credentials for VMware Customer Connect.

### Example 2

```powershell
Get-VCFDepotCredential -vxrail
```

This example shows how to retrieve the credentials for Dell EMC Support.

## Parameters

### -vxrail

Specifies that the cmdlet retrieves the credentials for Dell EMC Support.

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
