# Get-VCFHealthSummaryTask

## Synopsis

Retrieves the Health Summary tasks.

## Syntax

```powershell
Get-VCFHealthSummaryTask [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFHealthSummaryTask` cmdlet retrieves the Health Summary tasks.

## Examples

### Example 1

```powershell
Get-VCFHealthSummaryTask
```

This example shows how to retrieve the Health Summary tasks.

### Example 2

```powershell
Get-VCFHealthSummaryTask -id <task_id>
```

This example shows how to retrieve the Health Summary task by unique ID.

## Parameters

### -id

Specifies the unique ID of the Health Summary task.

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
