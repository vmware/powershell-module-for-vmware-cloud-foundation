# Get-CloudBuilderSDDCValidation

## Synopsis

Retrieves a list of management domain validations tasks from VMware Cloud Builder.

## Syntax

```powershell
Get-CloudBuilderSDDCValidation [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-CloudBuilderSDDCValidation` cmdlet retrieves a list of all SDDC validations from VMware Cloud Builder.

## Examples

### Example 1

```powershell
Get-CloudBuilderSDDCValidation
```

This example shows how to retrieve a list of all SDDC validations from VMware Cloud Builder.

### Example 2

```powershell
Get-CloudBuilderSDDCValidation -id 1ff80635-b878-441a-9e23-9369e1f6e5a3
```

This example shows how to retrieve a SDDC validation from VMware Cloud Builder by unique ID.

## Parameters

### -id

Specifies the unique ID of the management domain validation task.

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
