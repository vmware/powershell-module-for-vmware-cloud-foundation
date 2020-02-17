# Set-VCFBackupConfiguration

### Synopsis
Configure backup settings to backup NSX and SDDC manager

### Syntax
```
Get-VCFBackupConfiguration
```

### Description
Configures or updates the backup configuration details for backup up NSX and SDDC Manager

### Examples
#### Example 1
```
Set-VCFBackupConfiguration -privilegedUsername svc-mgr-vsphere@vsphere.local -privilegedPassword VMw@re1! -json backupConfiguration.json   
```
This example shows how to configure the backup configuration

### Parameters
#### -privilegedUsername
- Privileged Username for dual authentication

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -privilegedPassword
- Privileged Password for dual authentication

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -json
- Path to JSON file with credentials to be updated

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Sample JSON
#### Update Credentials with specified password
```
{
    "backupLocations": [ {
        "directoryPath": "/nfs/vmware/vcf/nfs-mount/backup",
        "password": "VMware123!",
        "port": 22,
        "protocol": "SFTP",
        "server": "192.168.110.55",
        "sshFingerprint": "SHA256:/VAp2bVvHlUeYv9qnSgqpVtx8kOQr9JoKhJiFnWW9sw",
        "username": "backup"
    } ],
    "encryption": {
        "passphrase": "VMware123!"
    }
}
```

### Notes

### Related Links
