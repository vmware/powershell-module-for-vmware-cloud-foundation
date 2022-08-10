---
title: "Remove-VCFCommissionedHost"
weight: 2
description: >
    Decommission hosts from VMware Cloud Foundation
---

## Syntax
``` powershell
Remove-VCFCommissionedHost -json <json_file>
```

### Parameters

| Required | Parameter | Type     |  Description                                                   |
| ---------| ----------|----------| -------------------------------------------------------------- |
| required | json      | String   | Specifies the JSON specification file to be used               | 


## Examples
### Example 1
``` powershell
Remove-VCFCommissionedHost -json .\Host\decommissionHostSpec.json
```
This example shows how to decommission a set of hosts based on the details provided in the JSON file.

## Sample JSON
### Decommission Hosts
```json
[ {
	"fqdn": "sfo01w01esx01.sfo.rainpole.io"
},{
	"fqdn": "sfo01w01esx02.sfo.rainpole.io"
},{
	"fqdn": "sfo01w01esx03.sfo.rainpole.io"
},{
	"fqdn": "sfo01w01esx04.sfo.rainpole.io"
}]

```
