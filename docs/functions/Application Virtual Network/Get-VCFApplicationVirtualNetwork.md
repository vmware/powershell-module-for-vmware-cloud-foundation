# Get-VCFApplicationVirtualNetwork

### Synopsis
Retrieves all Application Virtual Networks

### Syntax
```
Get-VCFApplicationVirtualNetwork -regionType <string>
```

### Description
The Get-VCFApplicationVirtualNetwork cmdlet retrieves the Application Virtual Networks configured in SDDC Manager
- regionType supports REGION_A, REGION_B, X_REGION

### Examples
#### Example 1
```
Get-VCFApplicationVirtualNetwork
```
This example demonstrates how to retrieve a list of Application Virtual Networks

#### Example 2
```
Get-VCFApplicationVirtualNetwork -regionType REGION_A
```
This example demonstrates how to retrieve the details of the regionType REGION_A Application Virtual Networks

#### Example 3
```
Get-VCFApplicationVirtualNetwork -id 577e6262-73a9-4825-bdb9-4341753639ce
```
This example demonstrates how to retrieve the details of the Application Virtual Networks using the id

### Parameters

#### -regionType
- regionType of the Application Virtual Network

```yaml
Type: String
Parameter Sets: REGION_A, REGION_B, X_REGION
Aliases:

Required: False
Position: Named
Default value: None
```

#### -id
- ID of the Application Virtual Network

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
