---
title: "Request-VCFToken"
weight: 2
description: >
    Request an authentication token from SDDC Manager
---

## Syntax
``` powershell
Request-VCFToken -fqdn <String> -Username <String> -Password <String>
```

### Parameters

| Required | Parameter | Type     |  Description                                                                                  |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------- |
| required | fqdn      | string   | Specifies the fully qualified domain name or IP Address of the SDDC Manager appliance         |
| required | username  | string   | Specifies the username to connect to the SDDC Manager appliance                               |
| required | password  | string   | Specifies the password for the user to connect to the SDDC Manager appliance                  |


## Examples
#### Example 1
``` powershell
Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username administrator@vsphere.local -password VMw@re1!
```
Connect to SDDC Manager to request API access & refresh tokens

#### Example 2
``` powershell
Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username admin@local -password VMw@re1!VMw@re1!
```
Connect to SDDC Manager using local account admin@local