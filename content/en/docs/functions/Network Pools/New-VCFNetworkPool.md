---
title: "New-VCFNetworkPool"
weight: 4
description: >
    Creates a network pool
---

## Syntax
``` powershell
New-VCFNetworkPool -json <json-file>
```

### Parameters

| Required | Parameter | Type     |  Description                                                                                                    |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------------------------- |
| required | json      | String   | Specifies the JSON specification file to be used                                                                | 

## Examples
### Example 1
``` powershell
New-VCFNetworkPool -json .\NetworkPool\createNetworkPoolSpec.json
```
Creates a Network Pool

## Sample JSON
``` json
{
	"name": "sfo01w01-cl01",
	"networks": [
		{
			"type": "VSAN",
			"vlanId": 2240,
			"mtu": 9000,
			"subnet": "172.16.240.0",
			"mask": "255.255.255.0",
			"gateway": "172.16.240.253",
			"ipPools": [
				{
					"start": "172.16.240.5",
					"end": "172.16.240.100"
				}
			]
		},
		{
			"type": "VMOTION",
			"vlanId": 2236,
			"mtu": 9000,
			"subnet": "172.16.236.0",
			"mask": "255.255.255.0",
			"gateway": "172.16.236.253",
			"ipPools": [
				{
					"start": "172.16.236.5",
					"end": "172.16.236.100"
				}
			]
		}
	]
}
```
