# Remove-VCFCommissionedHost

## Synopsis

Decommissions a list of ESXi hosts.

## Syntax

```powershell
Remove-VCFCommissionedHost [-json] <String> [<CommonParameters>]
```

## Description

The `Remove-VCFCommissionedHost` cmdlet decommissions a list of ESXi hosts.

## Examples

### Example 1

```powershell
Remove-VCFCommissionedHost -json (Get-Content -Raw .\samples\hosts\decommissionHostsSpec.json)
```

This example shows how to decommission a list of ESXi hosts using a JSON specification file.

???+ example "Sample JSON: Deommission ESXi Host(s)"

    ```json
    --8<-- "./samples/hosts/decommissionHostsSpec.json"
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
