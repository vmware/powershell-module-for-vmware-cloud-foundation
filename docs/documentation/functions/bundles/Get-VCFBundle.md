# Get-VCFBundle

## Synopsis

Retrieves a list of all bundles available to the SDDC Manager instance.

## Syntax

```powershell
Get-VCFBundle [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFBundle` cmdlet gets all bundles available to the SDDC Manager instance.

???+ info

    Includes bundles that are available via depot access and bundles that are manually uploaded.

## Examples

### Example 1

```powershell
Get-VCFBundle
```

This example shows how to retrieve a list of all bundles available to the SDDC Manager instance.

### Example 2

```powershell
Get-VCFBundle | Select version,downloadStatus,id
```

This example shows how to retrieve a list of all bundles available to the SDDC Manager instance and select specific properties.

### Example 3

```powershell
Get-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
```

This example shows how to retrieve a list of details for a specific bundle using the unique ID of the bundle.

### Example 4

```powershell
Get-VCFBundle | Where {$_.description -Match "NSX"}
```

This example shows how to retrieve a list of all bundles available to the SDDC Manager instance and filter the results by description.

## Parameters

### -id

Specifies the unique ID of the bundle.

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
