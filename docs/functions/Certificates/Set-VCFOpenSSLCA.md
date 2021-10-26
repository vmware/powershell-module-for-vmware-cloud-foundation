# Set-VCFOpenSSLCA

### Synopsis
Configures a OpenSSL Certificate Authority

### Syntax
```
Set-VCFOpenSSLCA -commonName <string> -organization <string> -organizationUnit <string> -locality <string> -state <string> -country <string>
```

### Description
Configures the OpenSSL Certificate Authorty on the connected SDDC Manager

### Examples
#### Example 1
```
Set-VCFOpenSSLCA -commonName sddcManager -organization Rainpole -organizationUnit Support -locality "Palo Alto" -state CA -country US
```
This example shows how to configure a OpenSSL certificate authority on the connected SDDC Manager

### Parameters

#### -commonName
- Common Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -organization
- Name of the Organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -organizationUnit
- Name of the Organizational Unit

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -locality
- Location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -state
- Name of the state

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -locality
- Country

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
