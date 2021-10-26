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
Set-VCFMicrosoftCA -serverUrl "https://rpl-dc01.rainpole.io/certsrv" -username Administrator -password "VMw@re1!" -templateName VMware
```
This example shows how to configure a Microsoft certificate authority on the connected SDDC Manager

### Parameters

#### -serverUrl
- URL of the Microsoft CA in quotes. e.g. "https://rpl-dc01.rainpole.io/certsrv"

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

### Related Links
