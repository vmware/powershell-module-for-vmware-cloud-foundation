# Set-VCFFederation

## Synopsis

Bootstraps the creation of a federation.

## Syntax

```powershell
Set-VCFFederation [-json] <String> [<CommonParameters>]
```

## Description

The `Set-VCFFederation` cmdlet bootstraps the creation of a federation in SDDC Manager.

???+ warning

    This API is was deprecated in VMware Cloud Foundation 4.3.0 and removed in VMware Cloud Foundation 4.4.0.

## Examples

### Example 1

```powershell
Set-VCFFederation -json (Get-Content -Raw .\samples\federation\federationSpec.json)
```

This example shows how to bootstrap the creation of a federation using a JSON specification file.

???+ example "Sample JSON: Create Federation"

    ```json
    --8<-- "./samples/federation/federationSpec.json"
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
