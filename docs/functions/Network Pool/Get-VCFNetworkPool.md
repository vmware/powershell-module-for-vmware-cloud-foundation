# Get-VCFNetworkPool

### Synopsis
Connects to the specified SDDC Manager and retrieves a list of Network Pools.

### Syntax
```
Get-VCFNetworkPool -name <string> -id <string>
```

### Description
The Get-VCFNetworkPool cmdlet connects to the specified SDDC Manager and retrieves a list of Network Pools.

### Examples
#### Example 1
```
Get-VCFNetworkPool
```
This example shows how to get a list of all Network Pools

#### Example 2
```
Get-VCFNetworkPool -name sfo01-networkpool
```
This example shows how to get a Network Pool by name

#### Example 3
```
Get-VCFNetworkPool -id 40b0b36d-36d6-454c-814b-ba8bf9b383e3
```
This example shows how to get a Network Pool by id

### Parameters

#### -name
- ID of target cluster

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -id
- ID of target cluster

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

### Notes

### Related Links
