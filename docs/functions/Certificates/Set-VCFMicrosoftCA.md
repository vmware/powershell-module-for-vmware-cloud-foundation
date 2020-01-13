# Set-VCFMicrosoftCA

### Synopsis
Configures a Microsoft Certificate Authority

### Syntax
```
Set-VCFMicrosoftCA -serverUrl <URL> -username <string> -password <string> -templateName <string>
```

### Description
Configures the Microsoft Certificate Authorty on the connected SDDC Manager

### Examples
#### Example 1
```
Set-VCFMicrosoftCA -serverUrl "https://rainpole.local/certsrv" -username Administrator -password "VMw@re1!" -templateName VMware
```
This example shows how to configure a Microsoft certificate authority on the connected SDDC Manager

### Parameters

#### -serverUrl
- URL of the Microsoft CA in quotes. e.g. "https://rainpole.local/certsrv"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -username
- Username of the Microsoft CA

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -password
- Password of the Microsoft CA user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -templateName
- Certificate Template Name to be Used

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Notes
Preparing a certificate template including configuring basic auth <a href="https://docs.vmware.com/en/VMware-Cloud-Foundation/3.9/com.vmware.vcf.admin.doc_39/GUID-BCD83622-4AB8-41EB-BD54-80F2B40FD9CE.html#GUID-BCD83622-4AB8-41EB-BD54-80F2B40FD9CE" target="_blank">Prepare the Certificate Service Template</a>

### Related Links
