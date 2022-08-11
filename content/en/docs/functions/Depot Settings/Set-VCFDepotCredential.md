---
title: "Set-VCFDepotCredential"
weight: 2
description: >
    Configure the My VMware credentials for the depot
---

## Syntax
``` powershell
Set-VCFDepotCredential -username <string> -password <string>
```

### Parameters

| Required | Parameter | Type     |  Description                                                             |
| ---------| ----------|----------| ------------------------------------------------------------------------ |
| required | username  | String   | Specifies the My VMware username for the depot connection                | 
| required | password  | Switch   | Specifies the My VMware password for the depot connection                | 


## Examples
### Example 1
``` powershell
Set-VCFDepotCredential -username "user@yourdomain.com" -password "VMware1!"
```
Configures the credentials for the depot