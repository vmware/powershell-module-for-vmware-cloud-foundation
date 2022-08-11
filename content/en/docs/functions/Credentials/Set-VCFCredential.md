---
title: "Set-VCFCredential"
weight: 4
description: >
    Updates the password for a credential
---

## Syntax
``` powershell
Set-VCFCredential -json <json_file>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| required | json       | String   | Specifies the JSON specification file to be used               | 

---
**Note**

Credentials can be updated with a specified password(s) or rotated using system generated password(s).

---

## Examples
### Example 1
``` powershell
Set-VCFCredential -json .\Credential\updateCredentialSpec.json
```
Update the password for a credential using the json spec

## Sample JSON
### Update Credential Password
``` json
{
  "operationType" : "UPDATE",
  "elements" : [ {
    "resourceName" : "sfo01-m01-esx02.sfo.rainpole.io",
    "resourceType" : "ESXI",
    "credentials" : [ {
      "credentialType" : "SSH",
      "username" : "root",
      "password" : "VMw@re1!"
    } ]
  } ]
}

```

### Rotate Credential Password
``` json
{
  "operationType" : "ROTATE",
  "elements" : [ {
    "resourceName" : "sfo01-m01-esx02.sfo.rainpole.io",
    "resourceType" : "ESXI",
    "credentials" : [ {
      "credentialType" : "SSH",
      "username" : "root"
    } ]
  } ]
}

```