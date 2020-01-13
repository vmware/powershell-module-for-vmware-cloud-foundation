# New-VCFLicenseKey

### Synopsis
Connects to the specified SDDC Manager and adds a new License Key.

### Syntax
```
New-VCFLicenseKey -json <path to JSON file>
```

### Description
The New-VCFLicenseKey cmdlet connects to the specified SDDC Manager and adds a new License Key.

### Examples
#### Example 1
```
New-VCFLicenseKey -json .\LicenseKey\addLicenseKeySpec.json
```
This example shows how to add a new License Key

### Parameters

#### -json
- Path to the JSON file

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
  "key" : "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA",
  "productType" : "NSXV",
  "description" : "NSX-V license key"
}

{
  "key" : "BBBBB-BBBBB-BBBBB-BBBBB-BBBBB",
  "productType" : "NSXT",
  "description" : "NSX-T license key"
}

{
  "key" : "CCCCC-CCCCC-CCCCC-CCCCC-CCCCC",
  "productType" : "VSAN",
  "description" : "vSAN license key"
}

{
  "key" : "DDDDD-DDDDD-DDDDD-DDDDD-DDDDD",
  "productType" : "SDDC_MANAGER",
  "description" : "SDDC Manager license key"
}

{
  "key" : "EEEEE-EEEEE-EEEEE-EEEEE-EEEEE",
  "productType" : "VCENTER",
  "description" : "vCenter license key"
}

{
  "key" : "FFFFF-FFFFF-FFFFF-FFFFF-FFFFF",
  "productType" : "ESXI",
  "description" : "ESXi license key"
}

{
  "key" : "GGGGG-GGGGG-GGGGG-GGGGG-GGGGG",
  "productType" : "VRA",
  "description" : "vRA license key"
}

{
  "key" : "HHHHH-HHHHH-HHHHH-HHHHH-HHHHH",
  "productType" : "VROPS",
  "description" : "vROPS license key"
}

```

### Notes

### Related Links
