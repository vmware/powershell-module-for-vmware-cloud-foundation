# Get-VCFNetworkIPPool

## Synopsis

Retrieves a list of all networks of a network pool.

## Syntax

```powershell
Get-VCFNetworkIPPool [-id] <String> [[-networkId] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFNetworkIPPool` cmdlet retrieves a list of all networks of a network pool.

## Examples

### Example 1

```powershell
Get-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52
```

This example shows how to retrieve a list of all networks of a network pool by unique ID.

### Example 2

```powershell
Get-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkId c2197368-5b7c-4003-80e5-ff9d3caef795
```

This example shows how to retrieve a list of details for a specific network associated to the network pool using the unique ID of the network pool and the unique ID of the network.

## Parameters

### -id

Specifies the unique ID of the network pool.

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

### -networkId

Specifies the unique ID of the network.

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
