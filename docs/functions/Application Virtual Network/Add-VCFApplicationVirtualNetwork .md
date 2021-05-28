# Add-VCFApplicationVirtualNetwork

### Synopsis
Creates Application Virtual Networks

### Syntax
```
Add-VCFApplicationVirtualNetwork -json <json_file> -validate
```

### Description
The Add-VCFApplicationVirtualNetwork cmdlet creates Application Virtual Networks in SDDC Manager and NSX-T Data Center

### Examples
#### Example 1
```
Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\SampleJSON\Application Virtual Network\avnOverlaySpec.json       
```
This example demonstrates how to deploy the Application Virtual Networks using the JSON spec supplied 

#### Example 2
```
Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\SampleJSON\Application Virtual Network\avnOverlaySpec.json) -validate
```
This example demonstrates how to validate the Application Virtual Networks JSON spec supplied

### Parameters
#### -json
- Path to JSON based specification

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Required: True
Position: Named
Default value: None
```

#### -validate
- Switch to perform validation only

```yaml
Type: Switch
Parameter Sets: (All)
Aliases:
Required: True
Position: Named
Default value: None
```

### Sample JSON
#### Deploy Overlay-backed NSX Segments for Application Virtual Networks
```
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

#### Deploy VLAN-backed NSX Segments for Application Virtual Networks
```
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

### Notes

### Related Links
