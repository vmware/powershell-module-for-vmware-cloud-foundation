---
title: "Add-VCFNetworkIPPool"
weight: 1
description: >
    Add an IP range to the Network of a Network Pool
---

## Syntax
``` powershell
Add-VCFNetworkIPPool -id <string> -networkid <string> -ipStart <string> -ipEnd <string>
```

### Parameters

| Required | Parameter | Type     |  Description                                                                                                    |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------------------------- |
| required | id        | String   | Specifies the unique ID of the target Network Pool                                                              | 
| required | networkId | String   | Specifies the unique ID of the target IP Pool                                                                   | 
| required | ipStart   | String   | Specifies the start IP for the new IP range                                                                     | 
| required | ipEnd     | String   | Specifies the end IP for the new IP range                                                                       | 

## Examples
### Example 1
``` powershell
Add-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795 -ipStart 192.168.110.61 -ipEnd 192.168.110.64
```
Create a new IP range on the existing IP Pool for a given Network Pool
