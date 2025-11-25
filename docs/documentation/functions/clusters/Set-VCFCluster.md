# Set-VCFCluster

## Synopsis

Expands or compacts a cluster by adding or removing a host(s). A cluster can also be marked for deletion.

## Syntax

```powershell
Set-VCFCluster [-id] <String> [[-json] <String>] [-markForDeletion] [<CommonParameters>]
```

## Description

The `Set-VCFCluster` cmdlet can be used to expand or compact a cluster by adding or removing a host(s). A cluster can also be marked for deletion.

???+ info

    Before a cluster can be removed it must first be marked for deletion.
    Please see [Remove-VCFCluster](Remove-VCFCluster.md) for more information.

## Examples

### Example 1

```powershell
Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -json .\samples\clusters\clusterExpansionSpec.json
```

This example shows how to expand a cluster by adding a host(s) using a JSON specification file.

???+ example "Sample JSON: Cluster Expansion"

    ```json
    --8<-- "./samples/clusters/clusterExpansionSpec.json"
    ```

### Example 2

```powershell
Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -json .\Cluster\clusterCompactionSpec.json
```

???+ example "Sample JSON: Cluster Compaction"

    ```json
    --8<-- "./samples/clusters/clusterCompactionSpec.json"
    ```

This example shows how to compact a cluster by removing a host(s) using a JSON specification file.

### Example 3

```powershell
Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -markForDeletion
```

This example shows how to mark a cluster for deletion.

## Parameters

### -id

Specifies the unique ID of the cluster.

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

### -json

Specifies the JSON specification to be used.

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

### -markForDeletion

Specifies the cluster is to be marked for deletion.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
