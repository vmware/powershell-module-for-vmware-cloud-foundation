---
title: "Set-VCFBackupConfiguration"
weight: 3
description: >
    Configures or updates the backup configuration details for backing up NSX and SDDC Manager
---

## Syntax
``` powershell
Set-VCFBackupConfiguration -json <json_file>
```

### Parameters

| Required | Parameter | Type     |  Description                                                   |
| ---------| ----------|----------| -------------------------------------------------------------- |
| required | json      | String   | Specifies the JSON specification file to be used               | 

## Examples
### Example 1
``` powershell
Set-VCFBackupConfiguration -json (Get-Content -Raw .\SampleJSON\Backup\backupConfiguration.json)  
```
This example shows how to configure the backup configuration

## Sample JSON
### Configure Backup Target

---
**Note**

Make sure you update <!!SSH-FINGERPRINT!!> with the SSH Fingerprint of your backup target.

---

``` json
{
    "backupLocations": [
        {
            "directoryPath": "/backups",
            "password": "VMw@re1!",
            "port": 22,
            "protocol": "SFTP",
            "server": "172.20.11.60",
            "sshFingerprint": "<!!SSH-FINGERPRINT!!>",
            "username": "svc-vcf-bck"
        }
    ],
    "encryption": {
        "passphrase": "VMw@re1!VMw@re1!"
    }
}
```