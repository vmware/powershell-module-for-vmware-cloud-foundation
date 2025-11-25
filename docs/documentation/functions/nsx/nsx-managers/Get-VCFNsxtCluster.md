# Get-VCFNsxtCluster

## Aliases

`Get-VCFNsxManagerCluster`

## Synopsis

Retrieves a list of NSX Managers managed by SDDC Manager.

## Syntax

```powershell
Get-VCFNsxtCluster [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFNsxtCluster` cmdlet retrieves a list of NSX Manager clusters managed by SDDC Manager.

## Examples

### Example 1

```powershell
Get-VCFNsxtCluster
```

This example shows how to retrieve the list of NSX Manager clusters managed by SDDC Manager.

### Example 2

```powershell
Get-VCFNsxtCluster -id d189a789-dbf2-46c0-a2de-107cde9f7d24
```

This example shows how to retrieve the NSX Manager cluster managed by SDDC Manager by unique ID.

### Example 3

```powershell
Get-VCFNsxtCluster | Select vipfqdn
```

This example shows how to retrieve the NSX Manager clusters managed by SDDC Manager and select the VIP FQDN.

## Parameters

### -id

Specifies the unique ID of the NSX Manager cluster.

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
