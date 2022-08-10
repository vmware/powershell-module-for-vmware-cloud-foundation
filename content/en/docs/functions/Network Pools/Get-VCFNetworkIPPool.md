---
title: "Get-VCFNetworkIPPool"
weight: 2
description: >
    Retrieves a list of all networks of a network pool
---

## Syntax
``` powershell
Get-VCFNetworkIPPool -id <string> -networkId <string>
```

### Parameters

| Required | Parameter | Type     |  Description                                                                                                    |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------------------------- |
| required | id        | String   | Specifies the unique ID of the Network Pool                                                                     | 
| optional | networkId | String   | Specifies the unique ID of the network                                                                          | 

## Examples
### Example 1
``` powershell
Get-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52
```
Retrieves a list of all networks associated to the network pool based on the unique ID

### Example 2
``` powershell
Get-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkId c2197368-5b7c-4003-80e5-ff9d3caef795 	
```
Retrieves the details of a network associated to the network pool using unique IDs
