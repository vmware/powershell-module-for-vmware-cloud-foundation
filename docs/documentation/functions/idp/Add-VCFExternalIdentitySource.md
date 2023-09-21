# Add-VCFExternalIdentitySource

## Synopsis

Adds an external identity source.

## Syntax

```powershell
Add-VCFExternalIdentitySource [-name] <String> [[-adfsCert] <Object>] [-username] <String> [-password] <String> [-usersBaseDn] <String> [-groupsBaseDn] <String> [[-ldapsCert] <Object>] [-clientId] <String> [-clientSecret] <String> [-discoveryEndpoint] <String> [-primaryLdapServerURL] <String> [[-secondaryLdapServerURL] <String>] [<CommonParameters>]
```

## Description

The `Add-VCFExternalIdentitySource` cmdlet adds an external identity source.

## Examples

### Example 1

```powershell
Add-VCFExternalIdentitySource -name "ADFS01" -username "svc-vcf-ca@rainpole.io" -password VMw@re123! -usersBaseDn "OU=Security Users,DC=rainpole,DC=io" -groupsBaseDn "OU=Security Groups,DC=rainpole,DC=io" -primaryLdapServerURL "ldaps://rpl-dc01.rainpole.io:636" -clientId "d49b72f6-ec04-41bb-bad6-aad368af2fe5" -clientSecret "HFEH59piO3NfzbFp9O5rGskCVEdBQ_aM8dTPo8wer" -discoveryEndpoint "https://rpl-dc01.rainpole.io/adfs/.well-known/openid-configuration" -adfsCert F:\certificates\adfsroot.cer -ldapsCert F:\certificates\ldapscert1.cer
```

This example shows how to add Active Directory Federation Services (AD FS) as an external identity provider using LDAPS protocol with Certificate Authority signed certificate.

### Example 2

```powershell
Add-VCFExternalIdentitySource -name "SFO01" -domainName "sfo.rainpole.io" -primaryLdapServerURL ldap://sfo-ad01.sfo.rainpole.io:389 -username "svc-vsphere-ad@sfo.rainpole.io" -password "VMw@re123!" -usersBaseDn "OU=Security Users,DC=sfo,DC=rainpole,DC=io" -groupsBaseDn "OU=Security Groups,DC=sfo,DC=rainpole,DC=io"
```

This example shows how to add Active Directory Federation Services (AD FS) as an external identity provider using LDAP protocol.

## Parameters

### -name

Specifies the name of the identity provider.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -adfsCert

Specifies the certificate file for the Active Directory Federation Services (AD FS) server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -username

Specifies the username for the Active Directory Federation Services (AD FS) server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -password

Specifies the password for the Active Directory Federation Services (AD FS) server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -usersBaseDn

Specifies the base distinguished name (DN) for the users.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -groupsBaseDn

Specifies the base distinguished name (DN) for the groups.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ldapsCert

Specifies the certificate file for the LDAP server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -clientId

Specifies the client ID for the Active Directory Federation Services (AD FS) server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -clientSecret

Specifies the client secret for the Active Directory Federation Services (AD FS) server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -discoveryEndpoint

Specifies the discovery endpoint for the Active Directory Federation Services (AD FS) server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -primaryLdapServerURL

Specifies the primary LDAP server URL.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -secondaryLdapServerURL

Specifies the secondary LDAP server URL.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
