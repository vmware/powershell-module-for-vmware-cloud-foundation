# Get-VCFCredential

### Synopsis
Connects to the specified SDDC Manager & retrieves a list of credentials.

### Syntax
```
Get-VCFCredential -privilegedUsername <string> -privilegedPassword <string> -resourceName <string>
```

### Description
The Get-VCFCredential cmdlet connects to the specified SDDC Manager and retrieves a list of credentials. A privileged user account is required.


### Examples
#### Example 1
```
Get-VCFCredential -privilegedUsername sec-admin@rainpole.local -privilegedPassword VMw@re1!
```
This example shows how to get a list of credentials

#### Example 2
```
Get-VCFCredential -privilegedUsername sec-admin@rainpole.local -privilegedPassword VMw@re1! -resourceName sfo01m01esx01.sfo.rainpole.local
```
This example shows how to get the credential for a specific resourceName (FQDN)

### Parameters

#### -privilegedUsername
- Privileged Username for dual authentication

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -privilegedPassword
- Privileged Password for dual authentication

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -resourceName
- Specific target resource to get credentials for

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accepted Value: Resource FQDN
```

### Notes

### Related Links
Steps to configure Dual Authentication https://docs.vmware.com/en/VMware-Cloud-Foundation/3.9/com.vmware.vcf.ovdeploy.doc_39/GUID-FAB78718-E626-4924-85DC-97536C3DA337.html
