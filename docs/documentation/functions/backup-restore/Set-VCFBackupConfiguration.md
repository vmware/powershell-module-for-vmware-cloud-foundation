# Set-VCFBackupConfiguration

## Synopsis

Configures or updates the backup configuration details for backing up NSX and SDDC Manager.

## Syntax

```powershell
Set-VCFBackupConfiguration [-json] <String> [<CommonParameters>]
```

## Description

The `Set-VCFBackupConfiguration` cmdlet configures or updates the backup configuration details for backing up NSX and SDDC Manager.

## Examples

### Example 1

```powershell
Set-VCFBackupConfiguration -json (Get-Content -Raw .\samples\backup-restore\backupSpec.json)
```

This example shows how to configure the backup configuration.

???+ example "Sample JSON: Configure Backup Settings"

    ```json
    --8<-- "./samples/backup-restore/backupSpec.json"
    ```

## Parameters

### -json

Specifies the JSON specification to be used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
