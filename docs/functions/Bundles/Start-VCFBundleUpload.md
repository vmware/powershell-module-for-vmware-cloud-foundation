# Start-VCFBundleUpload

### Synopsis
The Start-VCFBundleUpload starts upload of bundle to SDDC Manager

### Syntax
```
Start-VCFBundleUpload -json <path to json file>
```

### Description
The Start-VCFBundleUpload cmdlet starts upload of bundle(s) to SDDC Manager
Prerequisite: The bundle should have been downloaded to SDDC Manager VM using the bundle transfer utility tool

### Examples
#### Example 1
```
Start-VCFBundleUpload -json .\Bundle\bundlespec.json
```
This example invokes the upload of a bundle onto SDDC Manager

### Parameters

#### -json
- Path to the JSON spec

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
