# Remove-VCFLicenseKey

### Synopsis
Connects to the specified SDDC Manager an deletes a license key.

## Syntax
```
Remove-VCFLicenseKey -key <string>
```

### Description
The Remove-VCFLicenseKey cmdlet connects to the specified SDDC Manager and deletes a License Key. A license Key can only be removed if it is not in use.

### Examples
#### Example 1
```
Remove-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
```
This example shows how to delete a License Key

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

### Notes

### Related Links
