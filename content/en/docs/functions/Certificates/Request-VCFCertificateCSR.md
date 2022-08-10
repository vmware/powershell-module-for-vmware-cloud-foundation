---
title: "Request-VCFCertificateCSR"
weight: 6
description: >
    Generate a certificate signing request(s) (CSR) for the selected resource(s) in a domain
---

## Syntax
``` powershell
Get-VCFCertificateCSRs -domainName <string> -json <json_file>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| required | domainName | String   | Specifies the name of the domain                               | 
| required | json       | String   | Specifies the JSON specification file to be used               | 

---
**Prerequisites**

Resource types include SDDC_MANAGER, VCENTER, NSXT_MANAGER, VRA, VRLI, VROPS, VRSLCM, VXRAIL_MANAGER

---

## Examples
### Example 1
``` powershell
Request-VCFCertificateCSR -domainName sfo-m01 -json .\requestCsrSpec.json
```
Generates certificate signing request(s) (CSR) based on the entries within the requestCsrSpec.json file for resources within the domain

## Sample JSON
### Generate Certificate Signing Request

```json
{
    "csrGenerationSpec": {
        "country": "US",
        "email": "",
        "keyAlgorithm": "RSA",
        "keySize": "2048",
        "locality": "Palo Alto",
        "organization": "VMware",
        "organizationUnit": "IT",
        "state": "CA"
    },
    "resources": [
		{
			"fqdn": "sfo-vcf01.sfo.rainpole.io",
			"name": "sfo-vcf01",
			"resourceId": "2c10305a-b77d-4f6c-a83e-9ccb803445f1",
			"type": "SDDC_MANAGER"
		}
	]
}
```