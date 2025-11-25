# Get-VCFRestoreTask

## Synopsis

Retrieves the status of the restore task.

## Syntax

```powershell
Get-VCFRestoreTask [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFRestoreTask` cmdlet retrieves the status of the restore task.

## Examples

### Example 1

```powershell
Get-VCFRestoreTask -id a5788c2d-3126-4c8f-bedf-c6b812c4a753
```

This example shows how to retrieve the status of the restore task by unique ID.

## Parameters

### -id

Specifies the unique ID of the restore task.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
