# Get-VCFFederationTask

## Synopsis

Retrieves the status of operations tasks in a federation.

## Syntax

```powershell
Get-VCFFederationTask [-id] <String> [<CommonParameters>]
```

## Description

The `Get-VCFFederationTask` cmdlet retrieves the status of operations tasks in a federation from SDDC Manager.

???+ warning

    This API is was deprecated in VMware Cloud Foundation 4.3.0 and removed in VMware Cloud Foundation 4.4.0.

## Examples

### Example 1

```powershell
Get-VCFFederationTask -id f6f38f6b-da0c-4ef9-9228-9330f3d30279
```

This example shows how to retrieve the status of operations tasks in a federation from SDDC Manager.

## Parameters

### -id

Specifies the unique ID of the federation task.

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
