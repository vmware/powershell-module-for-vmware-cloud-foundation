# Get-VCFCluster

## Synopsis

Retrieves a list of clusters.

## Syntax

```powershell
Get-VCFCluster [[-name] <String>] [[-id] <String>] [[-vdses] <Switch> [<CommonParameters>]
```

## Description

The `Get-VCFCluster` cmdlet retrieves a list of clusters from SDDC Manager. You can retrieve the clusters by unique ID or name.

## Examples

### Example 1

```powershell
Get-VCFCluster
```

This example shows how to retrieve a list of all clusters.

### Example 2

```powershell
Get-VCFCluster -name wld01-cl01
```

This example shows how to retrieve a cluster by name.

### Example 3

```powershell
Get-VCFCluster -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
```

This example shows how to retrieve a cluster by unique ID.

### Example 4

```powershell
Get-VCFCluster -id 8423f92e-e4b9-46e7-92f7-befce4755ba2 -vdses
```

This example shows how to retrieve the vds data of a cluster by unique ID.

## Parameters

### -name

Specifies the name of the cluster.

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

Specifies the unique ID of the cluster.

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

### -vdses

Specifies retrieving the vSphere Distributed Switches (VDS) for the cluster.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
