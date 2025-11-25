# Get-VCFConfigurationNTPValidation

## Synopsis

Retrieves the status of the validation of the NTP configuration.

## Syntax

```powershell
Get-VCFConfigurationNTPValidation [-id] <String> [<CommonParameters>]
```

## Description

The `Get-VCFConfigurationNTPValidation` cmdlet retrieves the status of the validation of the NTP configuration.

## Examples

### Example 1

```powershell
Get-VCFConfigurationNTPValidation -id a749fcc5-fb61-2d05-aa40-9c7686164fc2
```

This example shows how to retrieve the status of the validation of the NTP configuration.

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
