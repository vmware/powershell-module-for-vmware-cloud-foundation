---
title: "Get-VCFBundle"
weight: 1
description: >
    Get all bundles available to SDDC Manager
---

## Syntax
``` powershell
Get-VCFBundle -id <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| optional | id         | String   | Specifies the unique ID of the bundle                          |

## Examples
### Example 1
``` powershell
Get-VCFBundle
```
Retrieves a list of all bundles and their details

#### Example 2
``` powershell
Get-VCFBundle | Select version,downloadStatus,id  
```
Retrieves a list of bundles and filters on the version, download status and the id only

#### Example 3
``` powershell
Get-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db   
```
Retrieves the details of a specific bundle by its id

#### Example 4
``` powershell
Get-VCFBundle | Where {$_.description -Match "vRealize"}
```
Retrieves a list of all bundles that match vRealize in the description field