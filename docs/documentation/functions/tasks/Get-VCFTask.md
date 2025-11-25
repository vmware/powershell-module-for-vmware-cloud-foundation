# Get-VCFTask

## Synopsis

Retrieves a list of tasks.

## Syntax

```powershell
Get-VCFTask [[-id] <String>] [[-status] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFTask` cmdlet retrieves a list of tasks from the SDDC Manager.

## Examples

### Example 1

```powershell
Get-VCFTask
```

This example shows how to retrieve all tasks.

### Example 2

```powershell
Get-VCFTask -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a
```

This example shows how to retrieve a task by unique ID.

### Example 3

```powershell
Get-VCFTask -status SUCCESSFUL
```

This example shows how to retrieve all tasks with a specific status.

## Parameters

### -id

Specifies the unique ID of the task to retrieve.

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

### -status

Specifies the status of the task to retrieve. One of: SUCCESSFUL, FAILED.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
