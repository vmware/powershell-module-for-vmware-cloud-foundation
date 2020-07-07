# Set-VCFConfigurationNTP

### Synopsis
Configures NTP for all systems

### Syntax
```
Set-VCFConfigurationNTP
```

### Description
The Set-VCFConfigurationNTP cmdlet configures the NTP Server for all systems managed by SDDC Manager

### Examples
#### Example 1
```
PS C:\> Set-VCFConfigurationNTP -json $jsonSpec
```
This example shows how to configure the NTP Servers for all systems managed by SDDC Manager using a variable

#### Example 2
```
PS C:\> Set-VCFConfigurationNTP (Get-Content -Raw .\dnsSpec.json)
```
This example shows how to configure the NTP Servers for all systems managed by SDDC Manager using a JSON file

#### Example 3
```
PS C:\> Set-VCFConfigurationNTP -json $jsonSpec -validate
```
This example shows how to validate the NTP configuration only

### Parameters

### Notes

### Related Links
