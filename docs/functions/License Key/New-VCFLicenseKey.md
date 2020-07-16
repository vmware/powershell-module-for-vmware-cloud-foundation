# New-VCFLicenseKey

### Synopsis
Connects to the specified SDDC Manager and adds a new License Key.

### Syntax
```
New-VCFLicenseKey -key <string> -productType <string> -description <string>
```

### Description
The New-VCFLicenseKey cmdlet connects to the specified SDDC Manager and adds a new License Key.

### Examples
#### Example 1
```
New-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA" -productType VCENTER -description "vCenter License"
```
This example shows how to add a new License key to SDDC Manager

### Parameters

#### -key
- License Key

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -productType
- Product Type

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accepted Value: SDDC_MANAGER,VCENTER,VSAN,ESXI,NSXT
```

#### -description
- Description for the key

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Notes

### Related Links
