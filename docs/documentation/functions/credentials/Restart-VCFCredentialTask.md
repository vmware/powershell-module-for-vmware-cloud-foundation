# Restart-VCFCredentialTask

## Synopsis

Restarts a failed rotate/update password task.

## Syntax

```powershell
Restart-VCFCredentialTask [-id] <String> [-json] <String> [<CommonParameters>]
```

## Description

The `Restart-VCFCredentialTask` cmdlet restarts a failed rotate/update password task. You can restart a failed rotate/update password task by unique ID and JSON specification file.

## Examples

### Example 1

```powershell
Restart-VCFCredentialTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d -json .\samples\credentials\updateCredentialSpec.json
```

This example shows how to update passwords of a resource type using a JSON specification file.

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

### -json

Specifies the JSON specification to be used.

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
