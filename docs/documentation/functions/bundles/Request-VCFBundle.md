# Request-VCFBundle

## Synopsis

Start download of bundle from depot.

## Syntax

```powershell
Request-VCFBundle [-id] <String> [<CommonParameters>]
```

## Description

The `Request-VCFBundle` cmdlet starts an immediate download of a bundle from the depot.

???+ note

    Only one download can be triggered for a bundle.

## Examples

### Example 1

```powershell
Request-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
```

This example shows how to start an immediate download of a bundle from the depot using the unique ID of the bundle.

## Parameters

### -id

Specifies the unique ID of the bundle.

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
