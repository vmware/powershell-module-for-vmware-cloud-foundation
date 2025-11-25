# New-VCFNetworkPool

## Synopsis

Adds a network pool.

## Syntax

```powershell
New-VCFNetworkPool [-json] <String> [<CommonParameters>]
```

## Description

The `New-VCFNetworkPool` cmdlet adds a network pool.

## Examples

### Example 1

```powershell
New-VCFNetworkPool -json (Get-Content -Raw .\samples\network-pools\networkPoolSpec.json)
```

This example shows how to add a network pool using a JSON specification file.

???+ example "Sample JSON: Add Network Pool"

    ```json
    --8<-- "./samples/network-pools/networkPoolSpec.json"
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
