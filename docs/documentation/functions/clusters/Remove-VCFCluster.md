# Remove-VCFCluster

## Synopsis

Removes a cluster from a workload domain.

## Syntax

```powershell
Remove-VCFCluster [-id] <String> [<CommonParameters>]
```

## Description

The `Remove-VCFCluster` cmdlet removes a cluster from a workload domain.

???+ note

    Before a cluster can be deleted it must first be marked for deletion.
    Please see [Set-VCFCluster](Set-VCFCluster.md) for more information.

## Examples

### Example 1

```powershell
Remove-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1
```

This example shows how to remove a cluster from a workload domain by unique ID.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
