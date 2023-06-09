# Get-VCFEdgeCluster

## Synopsis

Retrieves a list of NSX Edge Clusters managed by SDDC Manager.

## Syntax

```powershell
Get-VCFEdgeCluster [[-id] <String>] [<CommonParameters>]
```

## Description

The Get-VCFEdgeCluster cmdlet retrieves a list of NSX Edge Clusters managed by SDDC Manager.

## Examples

### Example 1

```powershell
Get-VCFEdgeCluster
```

This example shows how to retrieve the list of NSX Edge Clusters managed by SDDC Manager.

### Example 2

```powershell
Get-VCFEdgeCluster -id b4e3b2c4-31e8-4816-b1c5-801e848bef09
```

This example shows how to retrieve the NSX Edge Cluster managed by SDDC Manager by unique ID.

## Parameters

### -id

Specifies the unique ID of the NSX Edge Cluster.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
