# Set-VCFBackupConfiguration

### Synopsis
Configure backup settings for NSX and SDDC manager

### Syntax
```
Get-VCFBackupConfiguration
```

### Description
The Set-VCFBackupConfiguration cmdlet configures or updates the backup configuration details for backing up NSX and SDDC Manager

### Examples
#### Example 1
```
Set-VCFBackupConfiguration -json (Get-Content -Raw .\SampleJSON\Backup\backupConfiguration.json)  
```
This example shows how to configure the backup configuration

### Parameters
#### -json
- Path to JSON based specification

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Sample JSON
#### Updated the SSH Fingerprint
```
{
    "backupLocations": [
        {
            "directoryPath": "/tmp/backups",
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

### Notes

### Related Links
