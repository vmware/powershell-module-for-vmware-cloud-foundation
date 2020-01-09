# Commission-VCFHost

## SYNOPSIS
Connects to the specified SDDC Manager & commissions a list of hosts.

## SYNTAX

```
Commission-VCFHost -json <json file>
```

## DESCRIPTION
    The Commission-VCFHost cmdlet connects to the specified SDDC Manager 
	& commissions a list of hosts. Host list spec is provided in a JSON file.	


## EXAMPLES

### EXAMPLE 1
```
Commission-VCFHost -json .\Host\commissionHosts\commissionHostSpec.json
```

## PARAMETERS

### -json
Path to the json spec

```yaml
Type: JSON
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### Sample JSON
```json
[
        {
            "fqdn": "sfo01w01esx01.sfo01.rainpole.local",
            "username": "root",
            "storageType": "VSAN",
            "password": "VMw@re1!",
            "networkPoolName": "sfo01w01-cl01",
			"networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"
        },
        {
            "fqdn": "sfo01w01esx02.sfo01.rainpole.local",
            "username": "root",
            "storageType": "VSAN",
            "password": "VMw@re1!",
            "networkPoolName": "sfo01w01-cl01",
			"networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"

        },
		{
            "fqdn": "sfo01w01esx03.sfo01.rainpole.local",
            "username": "root",
            "storageType": "VSAN",
            "password": "VMw@re1!",
            "networkPoolName": "sfo01w01-cl01",
			"networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"
        },
		{
            "fqdn": "sfo01w01esx04.sfo01.rainpole.local",
            "username": "root",
            "storageType": "VSAN",
            "password": "VMw@re1!",
            "networkPoolName": "sfo01w01-cl01",
			"networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"
        }
    ]

```

## NOTES

## RELATED LINKS
