# Get-VCFNetworkPool

## Synopsis

Retrieves a list of all network pools.

## Syntax

```powershell
Get-VCFNetworkPool [[-name] <String>] [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFNetworkPool` cmdlet retrieves a list of all network pools.

## Examples

### Example 1

```powershell
Get-VCFNetworkPool
```

This example shows how to retrieve a list of all network pools.

### Example 2

```powershell
Get-VCFNetworkPool -name sfo01-networkpool
```

This example shows how to retrieve a network pool by name.

### Example 3

```powershell
Get-VCFNetworkPool -id 40b0b36d-36d6-454c-814b-ba8bf9b383e3
```

This example shows how to retrieve a network pool by unique ID.

## Parameters

### -name

Specifies the name of the network pool.

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

### -id

Specifies the unique ID of the network pool.

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
