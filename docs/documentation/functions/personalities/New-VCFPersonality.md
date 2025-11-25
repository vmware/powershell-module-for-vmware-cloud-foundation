# New-VCFPersonality

## Synopsis

Adds a vSphere Lifecycle Manager personality/image in the SDDC Manager inventory from an existing vLCM image based cluster.

## Syntax

```powershell
New-VCFPersonality [-name] <String> [-vCenterId] <String> [-clusterId] <String> [<CommonParameters>]
```

## Description

The `New-VCFPersonality` creates a new vSphere Lifecycle Manager personalities/image in the SDDC Manager inventory from an existing vLCM cluster.

## Examples

### Example 1

```powershell
New-VCFPersonality -name "vSphere 8.0U1" -vCenterId 6c7c3aaa-79cb-42fd-ade3-353f682cb1dc -clusterId "domain-c44"
```

This example shows how to add a new vSphere Lifecycle Manager personality/image in the SDDC Manager inventory from an existing vLCM image based cluster.

## Parameters

### -name

Specifies the image name.

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

### -vCenterId

Specifies the unique ID of the vCenter Server from which the cluster image will be imported.

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

### -clusterId

Specifies the unique ID of the vSphere cluster from which the image will be imported. Can be the vSphere MOID or cluster ID in SDDC Manager.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
