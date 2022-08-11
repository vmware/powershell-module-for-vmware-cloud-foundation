---
title: "Get-VCFCredentialTask"
weight: 2
description: >
    Retrieve a list of credential tasks
---

## Syntax
``` powershell
Get-VCFCredentialTask -id <string> -resourceCredentials <switch> -status <string>
```

### Parameters

| Required | Parameter          | Type     |  Description                                                                                |
| ---------| -------------------|----------| ------------------------------------------------------------------------------------------- |
| optional | id                 | String   | Specifies the unique ID of the credential task                                              | 
| optional | resourceCredentials| Switch   | Specifies that resource credentials should be retrieved                                     |
| optional | status             | String   | Specifies the status of the credential task (SUCCESSFUL, FAILED, USER_CANCELLED)            | 


## Examples
### Example 1
``` powershell
Get-VCFCredentialTask
```
Retrieves a list of all credentials tasks

### Example 2
``` powershell
Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3
```
Retrieve the credential task for a specific task id

### Example 3
``` powershell
Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3 -resourceCredentials
```
Retrieves resource credentials (for e.g. ESXI) for a credential task id