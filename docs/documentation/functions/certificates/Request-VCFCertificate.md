# Request-VCFCertificate

## Synopsis

Generate a certificate(s) for the selected resource(s) in a workload domain.

## Syntax

```powershell
Request-VCFCertificate [-json] <String> [-domainName] <String> [<CommonParameters>]
```

## Description

The `Request-VCFCertificate` cmdlet generates certificate(s) for the selected resource(s) in a workload domain.

???+ note

    The cerificate authority must be configured and the certificate signing request must be generated beforehand.

???+ info

    The resources that can be requested are: SDDC_MANAGER, PSC, VCENTER, NSX_MANAGER, NSXT_MANAGER, VRA, VRLI, VROPS, VRSLCM, VXRAIL_MANAGER.

## Examples

### Example 1

```powershell
Request-VCFCertificate -domainName MGMT -json (Get-Content -Raw .\samples\certificates\requestCertificateSpec.json)
```

This example shows how to generate the certificate(s) based on the entries within the JSON specification file for resources within the workload domain named MGMT.

???+ example "Sample JSON: Request Certificate"

    ```json
    --8<-- "./samples/certificates/requestCertificateSpec.json"
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

### -domainName

Specifies the name of the workload domain.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
