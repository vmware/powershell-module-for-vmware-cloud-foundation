# Set-VCFCertificate

## Synopsis

Install certificate(s) for the selected resource(s) in a workload domain.

## Syntax

```powershell
Set-VCFCertificate [-json] <String> [-domainName] <String> [<CommonParameters>]
```

## Description

The Set-VCFCertificate cmdlet installs certificate(s) for the selected resource(s) in a workload domain.

## Examples

### Example 1

```powershell
Set-VCFCertificate -domainName MGMT -json .\updateCertificateSpec.json
```

This example shows how to install the certificate(s) for the resources within the domain called MGMT based on the entries within the updateCertificateSpec.json file.

???+ example "Sample JSON: Install Certificates"

    ```json
    {
      "operationType": "INSTALL",
      "resources": [
        {
          "fqdn": "sfo-vcf01.sfo.rainpole.io",
          "name": "sfo-vcf01",
          "resourceId": "09a46df4-9492-4012-8213-c24f09414cb4",
          "type": "SDDC_MANAGER"
        },
        {
          "fqdn": "sfo-m01-nsx01.sfo.rainpole.io",
          "name": "sfo-m01-nsx01",
          "resourceId": "3d2ad408-075e-4833-a1cd-aef03ac12c6c",
          "type": "NSXT_MANAGER"
        },
        {
          "fqdn": "sfo-m01-vc01.sfo.rainpole.io",
          "name": "sfo-m01-vc01",
          "resourceId": "d9eadd12-1fed-440c-88cd-edebf8468318",
          "type": "VCENTER"
        }
      ]
    }
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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
