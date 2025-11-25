# Get-VCFWorkloadDomain

## Synopsis

Retrieves a list of workload domains.

## Syntax

```powershell
Get-VCFWorkloadDomain [[-name] <String>] [[-id] <String>] [-endpoints] [<CommonParameters>]
```

## Description

The `Get-VCFWorkloadDomain` cmdlet retrieves a list of workload domains from the SDDC Manager. You can filter the list by name or unique ID. You can also retrieve endpoints of a workload domain.

## Examples

### Example 1

```powershell
Get-VCFWorkloadDomain
```

This example shows how to retrieve a list of all workload domains.

### Example 2

```powershell
Get-VCFWorkloadDomain -name sfo-wld01
```

This example shows how to retrieve a workload domain by name.

### Example 3

```powershell
Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
```

This example shows how to retrieve a workload domain by unique ID.

### Example 4

```powershell
Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2 -endpoints | ConvertTo-Json
```

This example shows how to retrieve endpoints of a workload domain by unique ID and convert the output to JSON.

## Parameters

### -name

Specifies the name of the workload domain.

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

### -id

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

### -endpoints

Specifies to retrieve endpoints of the workload domain.

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
