# Request-VCFCertificate

### Synopsis
Generate certificate(s) for the selected resource(s) in a domain

### Syntax
```
Request-VCFCertificate -domainName <string> -json <path to json file>
```

### Description
The Request-VCFCertificate cmdlet generates certificate(s) for the selected resource(s) in a domain.
CA must be configured and CSR must be generated beforehand
..* Resource Types (SDDC_MANAGER, PSC, VCENTER, NSX_MANAGER, NSXT_MANAGER, VRA, VRLI, VROPS, VRSLCM, VXRAIL_MANAGER

### Examples
#### Example 1
```
Request-VCFCertificate -domainName MGMT -json .\requestCertificateSpec.json
```
This example requests the generation of the Certificates based on the entries within the requestCertificateSpec.json file for resources within the domain called MGMT

### Parameters

#### -domainName
- Name of the Management Domain

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -json
- Path to a JSON file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Sample JSON
```json
{
    "caType": "Microsoft",
    "resources": [ {
        "fqdn": "sfo01m01nsx01.sfo01.rainpole.io",
        "name": "sfo01m01nsx01",
        "resourceId": "c98e10e4-0f1f-4fd3-8e99-104115291a13",
        "type": "NSX_MANAGER"
    }
  ]
}
```

### Notes

### Related Links
