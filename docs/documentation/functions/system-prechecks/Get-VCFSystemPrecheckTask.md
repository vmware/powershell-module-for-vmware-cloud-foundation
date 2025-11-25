# Get-VCFSystemPrecheckTask

## Synopsis

Retrieves the status of a system level precheck task.

## Syntax

```powershell
Get-VCFSystemPrecheckTask [-id] <String> [<CommonParameters>]
```

## Description

The `Get-VCFSystemPrecheckTask` cmdlet retrieves the status of a system level precheck task that can be polled and monitored.

## Examples

### Example 1

```powershell
Get-VCFSystemPrecheckTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d
```

This example shows how to retrieve the status of a system level precheck task by unique ID.

### Example 2

```powershell
Get-VCFSystemPrecheckTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d -failureOnly
```

This example shows how to retrieve only failed subtasks from the system level precheck task by unique ID.

## Parameters

### -id

Specifies the unique ID of the system level precheck task.

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
### -failureOnly

Specifies to return only the failed subtasks.

```yaml
Type: Switch
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
