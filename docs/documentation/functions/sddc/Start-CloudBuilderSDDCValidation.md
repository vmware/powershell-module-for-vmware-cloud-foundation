# Start-CloudBuilderSDDCValidation

## Synopsis

Start the validation of a management domain JSON specification file on VMware Cloud Builder.

## Syntax

```powershell
Start-CloudBuilderSDDCValidation [-json] <String> [[-validation] <String>] [<CommonParameters>]
```

## Description

The `Start-CloudBuilderSDDCValidation` cmdlet starts the validation of a management domain JSON specification file on VMware Cloud Builder.

## Examples

### Example 1

```powershell
Start-CloudBuilderSDDCValidation -json .\samples\SDDC\SddcSpec.json
```

This example shows how to start the validation of a management domain JSON specification file on VMware Cloud Builder.

### Example 2

```powershell
Start-CloudBuilderSDDCValidation -json .\samples\SDDC\SddcSpec.json -validation LICENSE_KEY_VALIDATION
```

This example shows how to start the validation of a specific item in a management domain JSON specification file on VMware Cloud Builder.

## Parameters

### -json

Specifies the JSON specification to be used.

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

### -validation

Specifies the validation to be performed.

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
