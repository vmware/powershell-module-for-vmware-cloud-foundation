# Decommission-VCFHost

### Synopsis
Connects to the specified SDDC Manager and decommissions a list of hosts. Host list is provided in a JSON file.

### Syntax
```
Decommission-VCFHost -json <json file>
```

### Description
The Decommission-VCFHost cmdlet connects to the specified SDDC Manager and decommissions a list of hosts.

### Examples
#### Example 1
```
Decommission-VCFHost -json .\Host\decommissionHostSpec.json
```
This example shows how to decommission a set of hosts based on the details provided in the JSON file.

### Parameters

#### -json
- Path to the json spec

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
[ {
	"fqdn": "sfo01w01esx01.sfo.rainpole.local"
},{
	"fqdn": "sfo01w01esx02.sfo.rainpole.local"
},{
	"fqdn": "sfo01w01esx03.sfo.rainpole.local"
},{
	"fqdn": "sfo01w01esx04.sfo.rainpole.local"
}]

```

### Notes

### Related Links
