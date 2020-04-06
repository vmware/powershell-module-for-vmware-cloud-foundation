# Connect-CloudBuilder

### Synopsis
Connects to the specified Cloud Builder and stores the credentials in a base64 string

### Syntax
```
Connect-CloudBuilder -fqdn <string> -username <string> -password <string>
```

### Description
The Connect-CloudBuilder cmdlet connects to the specified Cloud Builder and stores the credentials in a
base64 string. It is required once per session before running all other cmdlets

### Examples
#### Example 1
```
Connect-CloudBuilder -fqdn sfo-cb01.sfo.rainpole.io -username admin -password VMware1!
```
This example shows how to connect to the Cloud Builder applaince


### Parameters

#### -fqdn
The fully qualified domain name of the Cloud Builder applaince to connect to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Username
Username of the Cloud Builder applaince to connect with (admin)

```yaml
Type: String
Parameter Sets: Username
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Password
Password to connect with

```yaml
Type: SecureString
Parameter Sets: Password
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Notes

### Related Links
