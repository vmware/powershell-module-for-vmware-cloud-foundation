# Add-VCFApplicationVirtualNetwork

## Synopsis

Creates Application Virtual Networks (AVN) in SDDC Manager and NSX.

## Syntax

```powershell
Add-VCFApplicationVirtualNetwork [-json] <String> [-validate] [<CommonParameters>]
```

## Description

The Add-VCFApplicationVirtualNetwork cmdlet creates Application Virtual Networks in SDDC Manager and NSX.

## Examples

### Example 1

```powershell
Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\SampleJSON\Application Virtual Network\avnOPverlaySpec.json)
```

This example shows how to deploy the Application Virtual Networks using the JSON specification file supplied.

### Example 2

```powershell
Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\SampleJSON\Application Virtual Network\avnOverlaySpec.json) -validate
```

This example shows how to validate the Application Virtual Networks JSON specification file supplied.

???+ example "Sample JSON: Overlay-backed NSX Segments for Application Virtual Networks"

    ```json
    {
    "edgeClusterId": "083741ad-6d64-4ea0-8117-ea940ca238d7",
    "avns": [
        {
        "name": "xreg-m01-seg01",
        "regionType": "X_REGION",
        "gateway": "192.168.11.1",
        "subnet": "192.168.11.0",
        "subnetMask": "255.255.255.0",
        "mtu": 9000,
        "routerName": "sfo-m01-ec01-t1-gw01",
        "portGroupName": "xreg-m01-seg01"
        },
        {
        "name": "sfo-m01-seg01",
        "regionType": "REGION_A",
        "subnet": "192.168.31.0",
        "gateway": "192.168.31.1",
        "subnetMask": "255.255.255.0",
        "mtu": 9000,
        "routerName": "sfo-m01-ec01-t1-gw01",
        "portGroupName": "sfo-m01-seg01"
        }
    ]
    }
    ```

???+ example "Sample JSON: VLAN-backed NSX Segments for Application Virtual Networks"

    ```json

    {
    "edgeClusterId": "083741ad-6d64-4ea0-8117-ea940ca238d7",
    "avns": [
        {
        "name": "xreg-m01-seg01",
        "regionType": "X_REGION",
        "gateway": "192.168.11.1",
        "subnet": "192.168.11.0",
        "subnetMask": "255.255.255.0",
        "mtu": 9000,
        "vlanId": 2021,
        "portGroupName": "xreg-m01-seg01"
        },
        {
        "name": "sfo-m01-seg01",
        "regionType": "REGION_A",
        "subnet": "192.168.31.0",
        "gateway": "192.168.31.1",
        "subnetMask": "255.255.255.0",
        "mtu": 9000,
        "vlanId": 2022,
        "portGroupName": "sfo-m01-seg01"
        }
    ]
    }
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

Specifies that the JSON specification should be validated.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
