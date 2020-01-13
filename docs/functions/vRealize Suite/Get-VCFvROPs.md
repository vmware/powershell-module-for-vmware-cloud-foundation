# Get-VCFvROPs

### Synopsis
Get the existing vRealize Operations Manager

### Syntax
```
Get-VCFvROPs -getIntegratedDomains -nodes
```

### Description
Gets the complete information about the existing vRealize Operations Manager.

### Examples
#### Example 1
```
Get-VCFvROPs
```
This example list all details concerning the vRealize Operations Manager

#### Example 2
```
Get-VCFvROPs -getIntegratedDomains
```
Retrieves all the existing workload domains and their connection status with vRealize Operations

#### Example 3
```
Get-VCFvROPs -nodes
```
Retrieves all the vRealize Operations Manager nodes

### Parameters

#### -getIntegratedDomains
- Get Workload domains that are integrated with vRealize Operations Manager. No value required

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -nodes
- Get vRealize Operations Manager nodes. No value required

```yaml
Type: SwitchParameter
Parameter Sets: Username
Aliases:

Required: False
Position: Named
Default value: None
```

### Notes

### Related Links
