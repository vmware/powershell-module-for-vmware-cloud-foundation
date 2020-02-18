# Set-VCFCertificate

### Synopsis
Replace certificate(s) for the selected resource(s) in a domain

### Syntax
```
Request-VCFCertificate -domainName <string> -json <path to json file>
```

### Description
The Set-VCFCertificate cmdlet replaces certificate(s) for the selected resource(s) in a domain

### Examples
#### Example 1
```
Set-VCFCertificate -domainName MGMT -json .\updateCertificateSpec.json
```
This example replaces the Certificates based on the entries within the updateCertificateSpec.json file for resources within the domain called MGMT

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
    "operationType": "INSTALL",
    "resources": [
		{
			"fqdn": "sfo01mgr01.sfo01.rainpole.local",
			"name": "sfo01mgr01",
			"resourceId": "09a46df4-9492-4012-8213-c24f09414cb4",
			"type": "SDDC_MANAGER"
		},{
			"fqdn": "sfo01m01nsx01.sfo01.rainpole.local",
			"name": "sfo01m01nsx01",
			"resourceId": "3d2ad408-075e-4833-a1cd-aef03ac12c6c",
			"type": "NSXT_MANAGER"
		},{
			"fqdn": "sfo01m01vc01.sfo01.rainpole.local",
			"name": "sfo01m01vc01",
			"resourceId": "d9eadd12-1fed-440c-88cd-edebf8468318",
			"type": "VCENTER"
		}
	]
}
```

### Notes

### Related Links
