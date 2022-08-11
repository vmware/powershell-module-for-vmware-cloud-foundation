# Start-VCFSystemPrecheck

### Synopsis
The Start-VCFSystemPrecheck cmdlet performs system level health checks

### Syntax
```
Start-VCFSystemPrecheck -json <path to json file>
```

### Description
The Start-VCFSystemPrecheck cmdlet performs system level health checks and upgrade pre-checks for an upgrade to be successful

### Examples
#### Example 1
```
Start-VCFSystemPrecheck -json .\SystemCheck\precheckVCFSystem.json
```
This example shows how to perform system level health check

### Parameters

### -json
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
