# Remove-VCFCommissionedHost

## Synopsis

Connects to the specified SDDC Manager and decommissions a list of hosts.
Host list is provided in a JSON file.

## Syntax

```powershell
Remove-VCFCommissionedHost [-json] <String> [<CommonParameters>]
```

## Description

The Remove-VCFCommissionedHost cmdlet connects to the specified SDDC Manager and decommissions a list of hosts.

## Examples

### Example 1

```powershell
Remove-VCFCommissionedHost -json (Get-Content -Raw .\samples\hosts\decommissionHostsSpec.json)
```

This example shows how to decommission a set of hosts based on the details provided in the JSON file.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
