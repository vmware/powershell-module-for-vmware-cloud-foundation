# Start-CloudBuilderSDDC

## Synopsis

Starts a management domain deployment task on VMware Cloud Builder.

## Syntax

```powershell
Start-CloudBuilderSDDC [-json] <String> [<CommonParameters>]
```

## Description

The `Start-CloudBuilderSDDC` cmdlet starts a management domain deployment task on VMware Cloud Builder using a JSON specification file.

## Examples

### Example 1

```powershell
Start-CloudBuilderSDDC -json .\samples\sddc\sddcSpec.json
```

This example shows how to start a management domain deployment task on VMware Cloud Builder using a JSON specification file.

???+ example "Sample JSON: Management Domain Bringup"

    ```json
    --8<-- "./samples/sddc/sddcSpec.json"
    ```

???+ example "Sample JSON: Multi-pNIC Management Domain Bringup"

    ```json
    --8<-- "./samples/sddc/multiPnicSddcSpec.json"
    ```

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
