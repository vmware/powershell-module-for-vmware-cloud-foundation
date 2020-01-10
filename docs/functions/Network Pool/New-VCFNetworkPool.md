# New-VCFNetworkPool

## SYNOPSIS
    Connects to the specified SDDC Manager & creates a new Network Pool.

## Syntax
```
New-VCFNetworkPool -json <path to JSON file>
```

## DESCRIPTION
    The Get-VCFNetworkPool cmdlet connects to the specified SDDC Manager & retrieves a list of Network Pools. 


## EXAMPLES

### EXAMPLE 1
```
New-VCFNetworkPool -json .\NetworkPool\createNetworkPoolSpec.json
    This example shows how to create a Network Pool
```

## PARAMETERS

### -json
- Path to JSON file

```yaml
Type: JSON
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```
## Sample JSON
```json
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
## NOTES

## RELATED LINKS
