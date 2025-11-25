# Start-VCFHealthSummary

## Synopsis

Starts the Health Summary checks.

## Syntax

```powershell
Start-VCFHealthSummary [-json] <String> [<CommonParameters>]
```

## Description

The `Start-VCFHealthSummary` cmdlet starts the Health Summary checks.

## Examples

### Example 1

```powershell
Start-VCFHealthSummary -json (Get-Content -Raw .\samples\sos\healthSummarySpec.json)
```

This example shows how to start the Health Summary checks using the JSON specification file.

???+ example "Sample JSON: Start Health Summary"

    ```json
    --8<-- "./samples/sos/healthSummarySpec.json"
    ```

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
