# Add-VCFEmbeddedIdentitySource

## Synopsis

Adds an embedded identity source.

## Syntax

```powershell
Add-VCFEmbeddedIdentitySource [-name] <String> [[-domainAlias] <String>] [-domainName] <String> [-username] <String> [-password] <String> [[-ldapsCert] <Object>] [-usersBaseDn] <String> [-groupsBaseDn] <String> [-primaryLdapServerURL] <String> [[-secondaryLdapServerURL] <String>] [<CommonParameters>]
```

## Description

The `Add-VCFEmbeddedIdentitySource` cmdlet adds an embedded identity source.

## Examples

### Example 1

```powershell
Add-VCFEmbeddedIdentitySource -name "SFO01" -domainName "sfo.rainpole.io" -primaryLdapServerURL ldaps://sfo-ad01.sfo.rainpole.io:636 -username "svc-vsphere-ad@sfo.rainpole.io" -password "VMw@re123!" -groupsBaseDn "OU=Security Groups,DC=sfo,DC=rainpole,DC=io" -usersBaseDn "OU=Security Users,DC=sfo,DC=rainpole,DC=io" -ldapsCert F:\certificates\Root64.cer
```

This example shows how to add an Active Directory over LDAP server as identity source using LDAPS protocol with Certificate Authority signed certificate.

### Example 2

```powershell
Add-VCFEmbeddedIdentitySource -name "SFO01" -domainName "sfo.rainpole.io" -primaryLdapServerURL ldaps://sfo-ad01.sfo.rainpole.io:636 -username "svc-vsphere-ad@sfo.rainpole.io" -password "VMw@re123!" -groupsBaseDn "OU=Security Groups,DC=sfo,DC=rainpole,DC=io" -usersBaseDn "OU=Security Users,DC=sfo,DC=rainpole,DC=io" -ldapsCert F:\certificates\Root64.cer,F:\certificates\cert1.cer
```

This example shows how to add an Active Directory over LDAP server as identity source using ldaps protocol with Certificate Authority signed certificates.

### Example 3

```powershell
Add-VCFEmbeddedIdentitySource -name "SFO01" -domainName "sfo.rainpole.io" -primaryLdapServerURL ldap://sfo-ad01.sfo.rainpole.io:389 -username "svc-vsphere-ad@sfo.rainpole.io" -password "VMw@re123!" -groupsBaseDn "OU=Security Groups,DC=sfo,DC=rainpole,DC=io" -usersBaseDn "OU=Security Users,DC=sfo,DC=rainpole,DC=io"
```

This example shows how to add an Active Directory over LDAP server as identity source using LDAP protocol.

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

### -domainAlias

Specifies the domain alias.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -domainName

Specifies the domain name.

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

### -username

Specifies the username.

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

### -password

Specifies the password.

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

### -ldapsCert

Specifies the LDAPS certificate file.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -usersBaseDn

Specifies the base distinguished name (DN) for users.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -groupsBaseDn

Specifies the base distinguished name (DN) for groups.

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

### -primaryLdapServerURL

Specifies the primary LDAP server URL.

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

### -secondaryLdapServerURL

Specifies the secondary LDAP server URL.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
