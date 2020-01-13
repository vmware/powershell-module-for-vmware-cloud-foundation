# Get-VCFvRLI

### Synopsis
Get the existing vRealize Log Insight Details

### Syntax
```
Get-VCFvRLI
```

### Description
Gets the complete information about the existing vRealize Log Insight deployment.

### Examples
#### Example 1
```
Get-VCFvRLI
```
This example list all details concerning the vRealize Log Insight Cluster

#### Example 2
```
Get-VCFvRLI | Select nodes | ConvertTo-Json
```
This example lists the node details of the cluster and outputs them in JSON format

### Parameters

### Notes

### Related Links
