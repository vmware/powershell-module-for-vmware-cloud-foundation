# Start-VCFSystemPrecheck

## Synopsis

Starts the system level health check.

## Syntax

```powershell
Start-VCFSystemPrecheck [-json] <String> [<CommonParameters>]
```

## Description

The `Start-VCFSystemPrecheck` cmdlet performs system level health checks and upgrade pre-checks.

## Examples

### Example 1

```powershell
Start-VCFSystemPrecheck -json (Get-Content -Raw .\samples\system-prechecks\precheckSpec.json)
```

This example shows how to perform system level health checks and upgrade pre-checks using the JSON specification file.

???+ example "Sample JSON: System Prechecks"

    ```json
    --8<-- "./samples/system-prechecks/precheckSpec.json"
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
