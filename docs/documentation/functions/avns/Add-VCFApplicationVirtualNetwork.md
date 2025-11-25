# Add-VCFApplicationVirtualNetwork

## Synopsis

Creates Application Virtual Networks (AVN) in SDDC Manager and NSX.

## Syntax

```powershell
Add-VCFApplicationVirtualNetwork [-json] <String> [-validate] [<CommonParameters>]
```

## Description

The `Add-VCFApplicationVirtualNetwork` cmdlet creates Application Virtual Networks in SDDC Manager and NSX.

## Examples

### Example 1

```powershell
Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\samples\avns\avnOPverlaySpec.json)
```

This example shows how to deploy the Application Virtual Networks using the JSON specification file supplied.

???+ example "Sample JSON: Overlay-backed NSX Segments for Application Virtual Networks"

    ```json
    --8<-- "./samples/avns/avnOverlaySpec.json"
    ```

### Example 2

```powershell
Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\samples\avns\avnOverlaySpec.json) -validate
```

This example shows how to validate the Application Virtual Networks JSON specification file supplied.

???+ example "Sample JSON: VLAN-backed NSX Segments for Application Virtual Networks"

    ```json
    --8<-- "./samples/avns/avnVlanSpec.json"
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
