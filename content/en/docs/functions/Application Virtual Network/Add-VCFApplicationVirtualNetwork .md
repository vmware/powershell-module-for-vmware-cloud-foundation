---
title: "Add-VCFApplicationVirtualNetwork"
weight: 1
description: >
    Creates Application Virtual Networks (AVN) in SDDC Manager
---

## Syntax
``` powershell
Add-VCFApplicationVirtualNetwork -json <json_file> -validate <switch>
```

### Parameters

| Required | Parameter | Type     |  Description                                                                                                    |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------------------------- |
| required | json      | String   | Specifies the JSON specification file to be used                                                                | 
| optional | validate  | Switch   | Specifies that the JSON specification file should be validated                                                  | 

## Examples
### Example 1
``` powershell
Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\SampleJSON\Application Virtual Network\avnOverlaySpec.json)     
```
Deploy the Application Virtual Networks using the JSON specification file supplied 

### Example 2
``` powershell
Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\SampleJSON\Application Virtual Network\avnOverlaySpec.json) -validate
```
Validate the Application Virtual Networks JSON specification file supplied

## Sample JSON

### Overlay-backed NSX Segments for Application Virtual Networks

``` json
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

### VLAN-backed NSX Segments for Application Virtual Networks

``` json
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
