---
title: "Connect-CloudBuilder"
weight: 1
description: >
    Request an authentication token from VMware Cloud Builder
---

## Syntax
``` powershell
Connect-CloudBuilder -fqdn <string> -username <string> -password <string>
```

### Parameters

| Required | Parameter | Type     |  Description                                                                                  |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------- |
| required | fqdn      | string   | Specifies the fully qualified domain name or IP Address of the VMware Cloud Builder appliance |
| required | username  | string   | Specifies the username to connect to the VMware Cloud Builder appliance (admin)               |
| required | password  | string   | Specifies the password for the user to connect to the VMware Cloud Builder appliance (admin)  |

## Examples
### Example 1
``` powershell
Connect-CloudBuilder -fqdn sfo-cb01.sfo.rainpole.io -username admin -password VMware1!
```
Connects to the VMware Cloud Builder appliance