---
title: "Get-VCFNetworkPool"
weight: 3
description: >
    Retrieves a list of all network pools
---

## Syntax
``` powershell
Get-VCFNetworkPool -name <string> -id <string>
```

### Parameters

| Required | Parameter | Type     |  Description                                                                                                    |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------------------------- |
| optional | name      | String   | Specifies the name of the Network Pool                                                                          | 
| optional | id        | String   | Specifies the unique ID of the network                                                                          | 

## Examples
#### Example 1
``` powershell
Get-VCFNetworkPool
```
Retrieves a list of all Network Pools

#### Example 2
``` powershell
Get-VCFNetworkPool -name sfo-m01-np01
```
Retrieves a Network Pool by name

#### Example 3
``` powershell
Get-VCFNetworkPool -id 40b0b36d-36d6-454c-814b-ba8bf9b383e3
```
Retrieves a Network Pool by its unique id
