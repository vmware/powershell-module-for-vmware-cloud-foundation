# Get-VCFConfigurationDNSValidation

## Synopsis

Retrieves the status of the validation of the DNS configuration.

## Syntax

```powershell
Get-VCFConfigurationDNSValidation [-id] <String> [<CommonParameters>]
```

## Description

The `Get-VCFConfigurationDNSValidation` cmdlet retrieves the status of the validation of the DNS configuration.

## Examples

### Example 1

```powershell
Get-VCFConfigurationDNSValidation -id d729fcc5-fb61-2d05-aa40-9c7686163fa1
```

This example shows how to retrieve the status of the validation of the DNS configuration.

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
