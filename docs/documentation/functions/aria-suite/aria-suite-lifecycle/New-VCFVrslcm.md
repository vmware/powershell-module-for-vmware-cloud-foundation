# New-VCFVrslcm

## Alias

`New-VCFAriaSuiteLifecycle`

## Synopsis

Deploys Aria Suite Lifecycle in the management domain in VMware Cloud Foundation mode.

## Syntax

```powershell
New-VCFVrslcm [-json] <String> [-validate] [<CommonParameters>]
```

## Description

The `New-VCFVrslcm` cmdlet deploys Aria Suite Lifecycle in the management domain in VMware Cloud Foundation mode.

## Examples

### Example 1

```powershell
New-VCFVrslcm -json (Get-Content -Raw .\samples\aria-suite\aria-lifecycle\deployAriaLifecycleAvnOverlaySpec.json)
```

This example shows how to deploy Aria Suite Lifecycle using a JSON specification file.

???+ example "Sample JSON: Deploy Aria Suite Lifecycle"

    ```json
    --8<-- "./samples/aria-suite/aria-lifecycle/deployAriaLifecycleAvnOverlaySpec.json"
    ```

### Example 2

```powershell
New-VCFVrslcm -json (Get-Content -Raw .\samples\aria-suite\aria-lifecycle\deployAriaLifecycleAvnOverlaySpec.json) -validate
```

This example shows how to validate a JSON specification file.

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
