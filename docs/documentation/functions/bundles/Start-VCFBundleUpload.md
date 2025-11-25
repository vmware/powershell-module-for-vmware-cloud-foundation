# Start-VCFBundleUpload

## Synopsis

Starts upload of bundle to SDDC Manager.

## Syntax

```powershell
Start-VCFBundleUpload [-json] <String> [<CommonParameters>]
```

## Description

The `Start-VCFBundleUpload` cmdlet starts upload of bundle(s) to SDDC Manager

???+ note

    The bundle must be downloaded to SDDC Manager appliance using the bundle transfer utility.

## Examples

### Example 1

```powershell
Start-VCFBundleUpload -json (Get-Content -Raw .\samples\bundles\bundleUploadSpec.json)
```

This example invokes the upload of a bundle onto SDDC Manager by passing a JSON specification file.

???+ example "Sample JSON: Upload Bundle"

    ```json
    --8<-- "./samples/bundles/bundleUploadSpec.json"
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
