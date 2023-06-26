# New-VCFEdgeCluster

## Synopsis

Creates an NSX Edge Cluster managed by SDDC Manager.

## Syntax

```powershell
New-VCFEdgeCluster [-json] <String> [-validate] [<CommonParameters>]
```

## Description

The New-VCFEdgeCluster cmdlet creates an NSX Edge Cluster managed by SDDC Manager.

## Examples

### Example 1

```powershell
New-VCFEdgeCluster -json (Get-Content -Raw .\samples\nsx\nsx-edge-clusters\edgeClusterSpec.json)
```

This example shows how to create an NSX Edge Cluster using a JSON specification file.

???+ example "Sample JSON: NSX Edge Cluster"

    ```json
    --8<-- "./samples/nsx/nsx-edge-clusters/edgeClusterSpec.json"
    ```

### Example 2

```powershell
New-VCFEdgeCluster -json (Get-Content -Raw .\samples\nsx\nsx-edge-clusters\edgeClusterSpec.json) -validate
```

This example shows how to validate the NSX Edge Cluster JSON specification file.

## Parameters

### -json

Specifies the JSON specification to be used.

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

### -validate

Specifies that the JSON specification should be validated.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
