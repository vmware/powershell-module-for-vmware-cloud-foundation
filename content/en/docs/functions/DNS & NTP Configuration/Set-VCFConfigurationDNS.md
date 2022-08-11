---
title: "Set-VCFConfigurationDNS"
weight: 5
description: >
    Configure DNS on all managed systems
---

## Syntax
``` powershell
Set-VCFConfigurationDNS -json <json_file> -validate
```

### Parameters

| Required | Parameter | Type     |  Description                                                   |
| ---------| ----------|----------| -------------------------------------------------------------- |
| required | json      | String   | Specifies the JSON specification file to be used               |
| optional | validate  | Switch   | Specifies that the JSON specification file should be validated |

## Examples
### Example 1
``` powershell
Set-VCFConfigurationDNS -json $jsonSpec
```
Configure the DNS Servers for all systems managed by SDDC Manager using a variable

### Example 2
``` powershell
Set-VCFConfigurationDNS -json (Get-Content -Raw .\dnsSpec.json)
```
Configure the DNS Servers for all systems managed by SDDC Manager using a JSON file

### Example 3
``` powershell
Set-VCFConfigurationDNS -json $jsonSpec -validate
```
Validate the DNS configuration only
