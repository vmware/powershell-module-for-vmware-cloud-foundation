# Start-VCFUpgrade

## Synopsis

Starts the upgrade of a resource.

## Syntax

```powershell
Start-VCFUpgrade [-json] <String> [<CommonParameters>]
```

## Description

The `Start-VCFUpgrade` cmdlet starts the upgrade of a resource in SDDC Manager.

## Examples

### Example 1


```powershell
Start-VCFUpgrade -json (Get-Content -Raw .\samples\upgrades\upgradeDomainSpec.json)
```

This example shows how to start an upgrade in SDDC Manager by using a JSON specification file.

???+ example "Sample JSON: Domain Upgrade"

    ```json
    --8<-- "./samples/upgrades/upgradeDomainSpec.json"
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
