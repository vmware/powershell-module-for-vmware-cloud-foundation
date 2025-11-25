# Start-VCFRestore

## Synopsis

Starts the SDDC Manager restore task.

## Syntax

```powershell
Start-VCFRestore [-backupFile] <String> [-passphrase] <String> [<CommonParameters>]
```

## Description

The `Start-VCFRestore` cmdlet starts the SDDC Manager restore task.

## Examples

### Example 1

```powershell
Start-VCFRestore -backupFile "/tmp/vcf-backup-sfo-vcf01-sfo-rainpole-io-yyyy-mm-dd-00-00-00.tar.gz" -passphrase "VMw@re1!VMw@re1!"
```

This example shows how to start the SDDC Manager restore task.

## Parameters

### -backupFile

Specifies the backup file to be used.

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

### -passphrase

Specifies the passphrase to be used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
