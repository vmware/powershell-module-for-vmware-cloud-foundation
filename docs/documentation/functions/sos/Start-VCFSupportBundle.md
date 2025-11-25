# Start-VCFSupportBundle

## Synopsis

Starts the support bundle generation.

## Syntax

```powershell
Start-VCFSupportBundle [-json] <String> [<CommonParameters>]
```

## Description

The `Start-VCFSupportBundle` cmdlet starts the support bundle generation.

## Examples

### Example 1

```powershell
Start-VCFSupportBundle -json (Get-Content -Raw .\samples\sos\supportBundleSpec.json)
```

This example shows how to start the support bundle generation using a JSON specification file.

???+ example "Sample JSON: Support Bundle Generation"

    ```json
    --8<-- "./samples/sos/supportBundleSpec.json"
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
