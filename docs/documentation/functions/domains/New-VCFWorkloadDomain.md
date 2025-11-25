# New-VCFWorkloadDomain

## Synopsis

Creates a workload domain.

## Syntax

```powershell
New-VCFWorkloadDomain [-json] <String> [<CommonParameters>]
```

## Description

The `New-VCFWorkloadDomain` cmdlet creates a workload domain from a JSON specification file.

## Examples

### Example 1

```powershell
New-VCFWorkloadDomain -json .\samples\domains\domainSpec.json
```

This example shows how to create a workload domain from a JSON specification file.

???+ example "Sample JSON: Workload Domain"

    ```json
    --8<-- "./samples/domains/domainSpec.json"
    ```
???+ example "Sample JSON: Isolated Workload Domain"

    ```json
    --8<-- "./samples/domains/isolatedDomainSpec.json"
    ```

### Example 2

```powershell
New-VCFWorkloadDomain -json .\samples\domains\domainSpec.json -validate
```

This example shows how to validate the workload domain JSON specification file.

## Parameters

### -json

Specifies the JSON specification to be used.

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

### -validate

Specifies to validate the JSON specification file.

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
