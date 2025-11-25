# Stop-VCFCredentialTask

## Synopsis

Stops a failed rotate/update password task.

## Syntax

```powershell
Stop-VCFCredentialTask [-id] <String> [<CommonParameters>]
```

## Description

The `Stop-VCFCredentialTask` cmdlet stops a failed rotate/update password task. You can stop a failed rotate/update password task by unique ID.

## Examples

### Example 1

```powershell
Stop-VCFCredentialTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d
```

This example shows how to cancel a failed rotate or update password task by unique ID.

## Parameters

### -id

Specifies the unique ID of the credential task.

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
