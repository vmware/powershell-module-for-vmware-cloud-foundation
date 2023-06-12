# Request-VCFCertificateCSR

## Synopsis

Generate a certificate signing request(s) (CSR) for the selected resource(s) in a workload domain.

## Syntax

```powershell
Request-VCFCertificateCSR [-json] <String> [-domainName] <String> [<CommonParameters>]
```

## Description

The Request-VCFCertificateCSR generates a certificate signing request(s) (CSR) for the selected resource(s) in a workload domain.

???+ info

    The resources that can be requested are: SDDC_MANAGER, PSC, VCENTER, NSX_MANAGER, NSXT_MANAGER, VRA, VRLI, VROPS, VRSLCM, VXRAIL_MANAGER.

## Examples

### Example 1

```powershell
Request-VCFCertificateCSR -domainName MGMT -json .\requestCsrSpec.json
```

This example shows how to generate the certificate signing request(s) (CSR) based on the entries within the requestCsrSpec.json file for resources within the workload domain named MGMT.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
