# Stop-CloudBuilderSDDCValidation

## Synopsis

Stop the in-progress validation of a management domain JSON specification file on VMware Cloud Builder.

## Syntax

```powershell
Stop-CloudBuilderSDDCValidation [-id] <String> [<CommonParameters>]
```

## Description

The `Stop-CloudBuilderSDDCValidation` cmdlet stops the in-progress validation of a management domain JSON specification file on VMware Cloud Builder.

## Examples

### Example 1

```powershell
Stop-CloudBuilderSDDCValidation -id bedf19f8-9dfe-4c60-aae4-bca986a65a31
```

This example shows how to stop a validation on VMware Cloud Builder based on the ID.

## Parameters

### -id

Specifies the unique ID of the management domain validation task.

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
