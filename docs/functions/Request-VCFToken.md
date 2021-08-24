# Request-VCFToken

### Synopsis
Connects to the specified SDDC Manager and requests API access & refresh tokens

### Syntax
```
Request-VCFToken -fqdn <String> -Username <String> -Password <String>
```

### Description
The Request-VCFToken cmdlet connects to the specified SDDC Manager and requests API access & refresh tokens.
It is required once per session before running all other cmdlets

### Examples
#### Example 1
```
Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username administrator@vsphere.local -password VMw@re1!
```
This example shows how to connect to SDDC Manager to request API access & refresh tokens

#### Example 2
```
Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username admin@local -password VMw@re1!VMw@re1!
```
This example shows how to connect to SDDC Manager using local account admin@local

### Parameters

#### -fqdn
The fully qualified domain name of the SDDC Manager to connect to

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
Username to connect with
User must be assigned the ADMIN role in SDDC Manager

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
