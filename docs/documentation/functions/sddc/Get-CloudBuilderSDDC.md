# Get-CloudBuilderSDDC

## Synopsis

Retrieves a list of management domain deployment from VMware Cloud Builder.

## Syntax

```powershell
Get-CloudBuilderSDDC [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-CloudBuilderSDDC` cmdlet retrieves a list of all SDDC deployments from VMware Cloud Builder.

## Examples

### Example 1

```powershell
Get-CloudBuilderSDDC
```

This example shows how to retrieve a list of all SDDC deployments from VMware Cloud Builder.

### Example 2

```powershell
Get-CloudBuilderSDDC -id 51cc2d90-13b9-4b62-b443-c1d7c3be0c23
```

This example shows how to retrieve a SDDC deployment from VMware Cloud Builder by unique ID.

## Parameters

### -id

Specifies the unique ID of the management domain deployment task.

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
