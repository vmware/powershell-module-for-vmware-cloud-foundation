---
title: "Set-VCFMicrosoftCA"
weight: 8
description: >
    Configures Microsoft Certificate Authority integration
---

## Syntax
``` powershell
Set-VCFMicrosoftCA -serverUrl <string> -username <string> -password <string> -templateName <string>
```

### Parameters

| Required | Parameter    | Type     |  Description                                                                               |
| ---------| -------------|----------| ------------------------------------------------------------------------------------------ |
| required | serverUrl    | String   | Specifies the https URL for the Microsoft Certificate Authority                            | 
| required | username     | String   | Specifies the username used to authenticate to the Microsoft Certificate Authority         | 
| required | password     | String   | Specifies the password used to authenticate to the Microsoft Certificate Authority         | 
| required | templateName | String   | Specifies the name of the certificate template used on the Microsoft Certificate Authority | 

## Examples
### Example 1
``` powershell
Set-VCFMicrosoftCA -serverUrl "https://rpl-dc01.rainpole.io/certsrv" -username Administrator -password "VMw@re1!" -templateName VMware
```
Configures Microsoft Certificate Authority integration with SDDC Manager