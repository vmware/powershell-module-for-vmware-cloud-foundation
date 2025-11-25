# Restart-VCFTask

## Synopsis

Retries a previously failed task.

## Syntax

```powershell
Restart-VCFTask [-id] <String> [<CommonParameters>]
```

## Description

The `Restart-VCFTask` cmdlet retries a previously failed task based on the unique ID of the task.

## Examples

### Example 1

```powershell
Restart-VCFTask -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a
```

This example shows how to restart a task by unique ID.

## Parameters

### -id

Specifies the unique ID of the task.

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
