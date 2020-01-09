# Decommission-VCFHost

## SYNOPSIS
Connects to the specified SDDC Manager & decommissions a list of hosts. Host list is provided in a JSON file.

## SYNTAX

```
Decommission-VCFHost -json <json file>
```

## DESCRIPTION
    The Decommission-VCFHost cmdlet connects to the specified SDDC Manager & decommissions a list of hosts.	


## EXAMPLES

### EXAMPLE 1
```
Decommission-VCFHost -json .\Host\decommissionHostSpec.json
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
[ {
	"fqdn": "sfo01w01esx01.sfo01.rainpole.local"
},{
	"fqdn": "sfo01w01esx02.sfo01.rainpole.local"
},{
	"fqdn": "sfo01w01esx03.sfo01.rainpole.local"
},{
	"fqdn": "sfo01w01esx04.sfo01.rainpole.local"
}]


```

## NOTES

## RELATED LINKS
