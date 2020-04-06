# Connect-VCFManager

### Synopsis
Connects to the specified SDDC Manager and requests API access & refresh tokens

### Syntax
```
Connect-VCFManager -fqdn <String> -Username <String> -Password <String>
```

### Description
The Connect-VCFManager cmdlet connects to the specified SDDC Manager and requests API access & refresh tokens.
  It is required once per session before running all other cmdlets

### Examples
#### Example 1
```
Connect-VCFManager -fqdn sfo01vcf01.sfo.rainpole.local -username sec-admin@rainpole.local -password VMware1!
```
This example shows how to connect to SDDC Manager

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
