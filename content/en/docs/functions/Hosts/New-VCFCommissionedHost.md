---
title: "New-VCFCommissionedHost"
weight: 1
description: >
    Commission hosts for VMware Cloud Foundation
---

## Syntax
``` powershell
New-VCFCommissionedHost -json <json_file> -validate <switch>
```

### Parameters

| Required | Parameter | Type     |  Description                                                   |
| ---------| ----------|----------| -------------------------------------------------------------- |
| required | json      | String   | Specifies the JSON specification file to be used               | 
| optional | validate  | Switch   | Specifies that the JSON specification file should be validated | 

## Examples
### Example 1
``` powershell
New-VCFCommissionedHost -json .\Host\commissionHosts\commissionHostSpec.json
```
Commissions a list of hosts based on the details provided in the JSON file

### Example 2
``` powershell
New-VCFCommissionedHost -json .\Host\commissionHosts\commissionHostSpec.json -validate
```
Validate the JSON spec before starting the workflow

## Sample JSON
### Commission Hosts
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
