# Set-VCFFederation

### Synopsis
Bootstrap a VMware Cloud Foundation to form a federation

### Syntax
```
Set-VCFFederation -json <string> or <file>
```

### Description
The Set-VCFFederation cmdlet bootstraps the creation of a Federation in VCF

### Examples
#### Example 1
```
Set-VCFFederation -json $jsonSpec
```
This example shows how to create a fedration using the using a variable

#### Example 2
```
Set-VCFFederation -json (Get-Content -Raw .\federationSpec.json)
```
This example shows how to create a fedration using the using a JSON file

### Parameters

### Notes

### Related Links
