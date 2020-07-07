# Set-VCFConfigurationDNS

### Synopsis
Configures DNS for all systems

### Syntax
```
Set-VCFConfigurationDNS
```

### Description
The Set-VCFConfigurationDNS cmdlet configures the DNS Server for all systems managed by SDDC Manager

### Examples
#### Example 1
```
PS C:\> Set-VCFConfigurationDNS -json $jsonSpec
```
This example shows how to configure the DNS Servers for all systems managed by SDDC Manager using a variable

#### Example 2
```
PS C:\> Set-VCFConfigurationDNS (Get-Content -Raw .\dnsSpec.json)
```
This example shows how to configure the DNS Servers for all systems managed by SDDC Manager using a JSON file

#### Example 3
```
PS C:\> Set-VCFConfigurationDNS -json $jsonSpec -validate
```
This example shows how to validate the DNS configuration only

### Parameters

### Notes

### Related Links
