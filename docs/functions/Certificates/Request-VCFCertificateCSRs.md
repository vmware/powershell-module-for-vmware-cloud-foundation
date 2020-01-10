# Request-VCFCertificateCSRs

## SYNOPSIS
    Generate CSR(s)

## Syntax
```
Get-VCFCertificateCSRs -domainName <string> -json <path to json file>
```

## DESCRIPTION
    Generate CSR(s) for the selected resource(s) in the domain
    - Resource Types (SDDC_MANAGER, PSC, VCENTER, NSX_MANAGER, NSXT_MANAGER, VRA,
      VRLI, VROPS, VRSLCM, VXRAIL_MANAGER

## EXAMPLES

### EXAMPLE 1
```
Request-VCFCertificateCSRs -domainName MGMT -json .\requestCsrSpec.json
    This example requests the generation of the CSR based on the entries within the requestCsrSpec.json file for resources within the domain called MGMT
```


## PARAMETERS

### -domainName
- Name of the Management Domain 

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### -json
- Path to a JSON file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

## SAMPLE JSON
```json
{
    "csrGenerationSpec": {
        "country": "US",
        "email": "",
        "keyAlgorithm": "RSA",
        "keySize": "2048",
        "locality": "Palo Alto",
        "organization": "VMware",
        "organizationUnit": "HCIBU",
        "state": "CA"
    },
    "resources": [
		{
			"fqdn": "sfo01mgr01.sfo01.rainpole.local",
			"name": "sfo01mgr01",
			"resourceId": "2c10305a-b77d-4f6c-a83e-9ccb803445f1",
			"type": "SDDC_MANAGER"
		},{
			"fqdn": "sfo01m01nsx01.sfo01.rainpole.local",
			"name": "sfo01m01nsx01",
			"resourceId": "c98e10e4-0f1f-4fd3-8e99-104115291a13",
			"type": "NSX_MANAGER"
		}
	]
}
```
## NOTES

## RELATED LINKS
