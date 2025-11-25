# Get-VCFApplicationVirtualNetwork

## Synopsis

Retrieves Application Virtual Networks (AVN) from SDDC Manager.

## Syntax

```powershell
Get-VCFApplicationVirtualNetwork [[-regionType] <String>] [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFApplicationVirtualNetwork` cmdlet retrieves the Application Virtual Networks configured in SDDC Manager.

## Examples

### Example 1

```powershell
Get-VCFApplicationVirtualNetwork
```

This example shows how to retrieve a list of Application Virtual Networks.

### Example 2

```powershell
Get-VCFApplicationVirtualNetwork -regionType REGION_A
```

This example shows how to retrieve the details of the regionType REGION_A Application Virtual Networks.

### Example 3

```powershell
Get-VCFApplicationVirtualNetwork -id 577e6262-73a9-4825-bdb9-4341753639ce
```

This example shows how to retrieve the details of the Application Virtual Networks using the id.

## Parameters

### -regionType

Specifies the region. One of: REGION_A, REGION_B, X_REGION.

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

Specifies the unique ID of the Application Virtual Network.

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
