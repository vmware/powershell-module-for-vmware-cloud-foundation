# Get-VCFClusterValidation

## Synopsis

Retrieves the status of the validation task for the cluster JSON specification.

## Syntax

```powershell
Get-VCFClusterValidation [-id] <String> [<CommonParameters>]
```

## Description

The `Get-VCFClusterValidation` cmdlet retrieves the status of the validation task for the cluster JSON specification.

## Examples

### Example 1

```powershell
Get-VCFClusterValidation -id 001235d8-3e40-4a5a-8a89-09985dac1434
```

This example shows how to retrieve validation task for the cluster JSON specification by unique ID.

## Parameters

### -id

Specifies the unique ID of the validation task.

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
