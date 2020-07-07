# Start-VCFUpgrade

### Synopsis
Schedule/Trigger Upgrade of a Resource

### Syntax
```
Start-VCFUpgrade
```

### Description
The Start-VCFUpgrade cmdlet triggers an upgrade of a resource in SDDC Manager

### Examples
#### Example 1
```
Start-VCFUpgrade -json $jsonSpec
```
This example invokes an upgrade in SDDC Manager using a variable

#### Example 2
```
Start-VCFUpgrade -json (Get-Content -Raw .\sddcManagerUpgrade.json)
```
This example invokes an upgrade in SDDC Manager by passing a JSON file

### Parameters

### Notes

### Related Links
