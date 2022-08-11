---
title: "Request-VCFCertificate"
weight: 5
description: >
    Generate a certificate(s) for the selected resource(s) in a domain
---

## Syntax
``` powershell
Request-VCFCertificate -domainName <string> -json <json_file>
```

### Parameters

| Required | Parameter  | Type     |  Description                                                   |
| ---------| -----------|----------| -------------------------------------------------------------- |
| required | domainName | String   | Specifies the name of the domain                               | 
| required | json       | String   | Specifies the JSON specification file to be used               | 

---
**Prerequisites**

The Certificate Authority must be configured and CSR must be generated beforehand, resource types include SDDC_MANAGER, VCENTER, NSXT_MANAGER, VRA, VRLI, VROPS, VRSLCM, VXRAIL_MANAGER

---

## Examples
### Example 1
``` powershell
Request-VCFCertificate -domainName sfo-m01 -json .\requestCertificateSpec.json
```
Generates certificates based on the entries within the requestCertificateSpec.json file for resources within the domain

## Sample JSON

### Generate Certificates
```json
{
    "caType": "Microsoft",
    "resources": [ {
        "fqdn": "sfo-m01-vc01.sfo.rainpole.io",
        "name": "sfo-m01-vc01",
        "resourceId": "c98e10e4-0f1f-4fd3-8e99-104115291a13",
        "type": "VCENTER"
    }
  ]
}
```