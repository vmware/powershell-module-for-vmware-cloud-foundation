# Get-VCFPSC

## Synopsis

Retrieves a list of Platform Services Controllers.

## Syntax

```powershell
Get-VCFPSC [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFPSC` cmdlet retrieves a list of all Platform Services Controllers.

## Examples

### Example 1

```powershell
Get-VCFPSC
```

This example shows how to retrieve a list of all Platform Services Controllers.

### Example 2

```powershell
Get-VCFPSC -id b4e3b2c4-31e8-4816-b1c5-801e848bef09
```

This example shows how to retrieve a Platform Services Controller by unique ID.

## Parameters

### -id

Specifies the unique ID of the Platform Services Controller.

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
