---
title: "Set-VCFConfigurationNTP"
weight: 6
description: >
   Configure NTP Server on all managed systems
---

## Syntax
``` powershell
Set-VCFConfigurationNTP -json <json_file> -validate
```

### Parameters

| Required | Parameter | Type     |  Description                                                   |
| ---------| ----------|----------| -------------------------------------------------------------- |
| required | json      | String   | Specifies the JSON specification file to be used               | 
| optional | validate  | Switch   | Specifies that the JSON specification file should be validated |

## Examples
### Example 1
``` powershell
Set-VCFConfigurationNTP -json $jsonSpec
```
Configure the NTP Servers for all systems managed by SDDC Manager using a variable

#### Example 2
``` powershell
Set-VCFConfigurationNTP (Get-Content -Raw .\dnsSpec.json)
```
Configure the NTP Servers for all systems managed by SDDC Manager using a JSON file

#### Example 3
``` powershell
Set-VCFConfigurationNTP -json $jsonSpec -validate
```
Validate the NTP configuration only
