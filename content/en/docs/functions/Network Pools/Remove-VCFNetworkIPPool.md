---
title: "Remove-VCFNetworkIPPool"
weight: 5
description: >
    Removes an IP Pool from the Network of a Network Pool
---

## Syntax
``` powershell
Remove-VCFNetworkIPPool -id <string> -networkId <string> -ipStart <string> -ipEnd <string>
```

### Parameters

| Required | Parameter | Type     |  Description                                                                                                    |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------------------------- |
| required | id        | String   | Specifies the unique ID of the network pool                                                                     |
| required | networkId | String   | Specifies the unique ID of the ip pool                                                                          |
| required | ipStart   | String   | Specifies the start IP for the new IP range                                                                     |
| required | ipEnd     | String   | Specifies the end IP for the new IP range                                                                       | 

## Examples
### Example 1
``` powershell
Remove-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795 -ipStart 192.168.110.61 -ipEnd 192.168.110.64
``` 
Removes an IP Pool on the existing network for a given Network Pool