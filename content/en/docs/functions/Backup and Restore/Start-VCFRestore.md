---
title: "Start-VCFRestore"
weight: 5
description: >
    Triggers a restore task for SDDC Manager
---

## Syntax
``` powershell
Start-VCFRestore -backupFile <string> -passphrase <string>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                    |
| ---------| -----------|----------| --------------------------------------------------------------- |
| required | backupFile | String   | Specifies the backup file that should be used for the restore   | 
| required | passphrase | String   | Specifies that security passphrase used to open the backup file | 

## Examples
### Example 1
``` powershell
Start-VCFRestore -backupFile "/tmp/vcf-backup-sfo-vcf01-sfo-rainpole-io-2020-04-20-14-37-25.tar.gz" -passphrase "VMw@re1!VMw@re1!"
```
Starts the SDDC Manager restore