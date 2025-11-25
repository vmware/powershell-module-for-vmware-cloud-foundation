# Get-VCFUpgrade

## Synopsis

Retrieves a list of upgradable resources.

## Syntax

```powershell
Get-VCFUpgrade [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFUpgrade` cmdlet retrieves a list of upgradable resources from SDDC Manager.

## Examples

### Example 1

```powershell
Get-VCFUpgrade
```

This example shows how to retrieve a list of upgradable resources from SDDC Manager.

### Example 2

```powershell
Get-VCFUpgrade -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a
```

This example shows how to retrieve an upgradable resource by unique ID.

## Parameters

### -id

Specifies the unique ID of the upgradable resource to retrieve.

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
