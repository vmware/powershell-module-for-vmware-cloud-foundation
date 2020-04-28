# Commission-VCFHost

### Synopsis
Connects to the specified SDDC Manager and commissions a list of hosts

### Syntax
```
Commission-VCFHost -json <json file> -validate <switch>
```

### Description
The Commission-VCFHost cmdlet connects to the specified SDDC Manager and commissions a list of hosts. Host list spec is provided in a JSON file

### Examples
#### Example 1
```
Commission-VCFHost -json .\Host\commissionHosts\commissionHostSpec.json
```
This example shows how to commission a list of hosts based on the details provided in the JSON file

#### Example 2
```
Commission-VCFHost -json .\Host\commissionHosts\commissionHostSpec.json -validate
```
This example shows how to validate the JSON spec before starting the workflow

### Parameters

#### -json
Path to the json spec

```yaml
Type: JSON
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Sample JSON
```json
[
    {
        "fqdn": "sfo01-w01-esx01.sfo.rainpole.io",
        "username": "root",
        "storageType": "VSAN",
        "password": "VMw@re1!",
        "networkPoolName": "sfo-w01-np01",
		"networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"
    },
    {
        "fqdn": "sfo01-w01-esx02.sfo.rainpole.io",
        "username": "root",
        "storageType": "VSAN",
        "password": "VMw@re1!",
        "networkPoolName": "sfo-w01-np01",
		"networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"
    },
	{
        "fqdn": "sfo01-w01-esx03.sfo.rainpole.io",
        "username": "root",
        "storageType": "VSAN",
        "password": "VMw@re1!",
        "networkPoolName": "sfo-w01-np01",
		"networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"
    },
	{
        "fqdn": "sfo01-w01-esx04.sfo.rainpole.io",
        "username": "root",
        "storageType": "VSAN",
        "password": "VMw@re1!",
        "networkPoolName": "sfo-w01-np01",
		"networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"
    }
]

```

### Notes

### Related Links
