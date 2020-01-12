# Set-VCFCeip

### Synopsis
    Sets the CEIP status (Enabled/Disabled) of the connected SDDC Manager

### Syntax
```
Set-VCFCeip -ceipSetting <string>
```

#### Description
The Set-VCFCeip cmdlet configures the status (Enabled/Disabled) for Customer Experience Improvement
Program (CEIP) of the connected SDDC Manager.

### Examples
#### Example 1
```
Set-VCFCeip -ceipSetting ENABLE    
```
This example shows how to disable CEIP of the connected SDDC Manager

### Parameters

### -ceipSetting
- Sets CEIP to Enable/Disable

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accepted Value: ENABLE,DISABLE
```

### Notes

### Related Links
