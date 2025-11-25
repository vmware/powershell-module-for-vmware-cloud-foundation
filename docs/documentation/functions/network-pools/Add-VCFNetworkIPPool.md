# Add-VCFNetworkIPPool

## Synopsis

Adds an IP pool to the an existing network of a network pool.

## Syntax

```powershell
Add-VCFNetworkIPPool [-id] <String> [-networkid] <String> [-ipStart] <String> [-ipEnd] <String> [<CommonParameters>]
```

## Description

The `Add-VCFNetworkIPPool` cmdlet adds an IP pool to an existing network of a network pool.

## Examples

### Example 1

```powershell
Add-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795 -ipStart 192.168.110.61 -ipEnd 192.168.110.64
```

This example shows how create an IP pool on the existing network of a network pool using the unique ID of the network pool, the unique ID of the network, and the start and end IP addresses for the new IP range.

## Parameters

### -id

Specifies the unique ID of the target Network Pool.

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

### -networkid

Specifies the unique ID of the target network.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ipStart

Specifies the start IP address for the new IP range.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ipEnd

Specifies the end IP address for the new IP range.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
