---
title: "Set-VCFCertificate"
weight: 7
description: >
    Install certificate(s) for the selected resource(s) in a domain
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

## Examples
### Example 1
``` powershell
Set-VCFCertificate -domainName sfo-m01 -json .\updateCertificateSpec.json
```
Installs certificates based on the entries within the updateCertificateSpec.json file for resources within the domain

## Sample JSON
### Install Certificates

```json
{
    "operationType": "INSTALL",
    "resources": [
		{
			"fqdn": "sfo-vcf01.sfo.rainpole.io",
			"name": "sfo-vcf01",
			"resourceId": "09a46df4-9492-4012-8213-c24f09414cb4",
			"type": "SDDC_MANAGER"
		},{
			"fqdn": "sfo-m01-nsx01.sfo.rainpole.io",
			"name": "sfo-m01-nsx01",
			"resourceId": "3d2ad408-075e-4833-a1cd-aef03ac12c6c",
			"type": "NSXT_MANAGER"
		},{
			"fqdn": "sfo-m01-vc01.sfo.rainpole.io",
			"name": "sfo-m01-vc01",
			"resourceId": "d9eadd12-1fed-440c-88cd-edebf8468318",
			"type": "VCENTER"
		}
	]
}
```