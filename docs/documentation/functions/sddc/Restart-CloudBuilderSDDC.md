# Restart-CloudBuilderSDDC

## Synopsis

Retry a failed management domain deployment task on VMware Cloud Builder.

## Syntax

```powershell
Restart-CloudBuilderSDDC [-id] <String> [[-json] <String>] [<CommonParameters>]
```

## Description

The `Restart-CloudBuilderSDDC` cmdlet retries a failed management domain deployment task on VMware Cloud Builder.

## Examples

### Example 1

```powershell
Restart-CloudBuilderSDDC -id bedf19f8-9dfe-4c60-aae4-bca986a65a31
```

This example shows how to retry a deployment on VMware Cloud Builder based on the ID.

### Example 2

```powershell
Restart-CloudBuilderSDDC -id bedf19f8-9dfe-4c60-aae4-bca986a65a31 -json .\samples\SDDC\SddcSpec.json
```

This example shows how to retry a deployment on VMware Cloud Builder based on the ID and an updated JSON specification file.

## Parameters

### -id

Specifies the unique ID of the management domain deployment task.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
