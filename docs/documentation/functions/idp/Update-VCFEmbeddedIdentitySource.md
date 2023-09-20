# Update-VCFEmbeddedIdentitySource

## Synopsis

Updates an embedded identity source.

## Syntax

```powershell
Update-VCFEmbeddedIdentitySource [[-name] <String>] [-domainName] <String> [[-username] <String>]
```

## Description

The `Update-VCFEmbeddedIdentitySource` cmdlet updates an embedded identity source.

## Examples

### Example 1

```powershell
Update-VCFEmbeddedIdentitySource -domainName sfo.rainpole.io -password VMw@re123! -primaryLdapServerURL ldaps://sfo-ad01.sfo.rainpole.io:636 -ldapsCert F:\certificates\Root64.cer
```

This example shows how to update an existing Active Directory over LDAP server using LDAPS protocol with Certificate Authority signed certificate.

### Example 2

```powershell
Update-VCFEmbeddedIdentitySource -domainName sfo.rainpole.io -password VMw@re123! -secondaryLdapServerURL ldap://sfo-ad01.sfo.rainpole.io:389
```

This example shows how to update an existing Active Directory server over LDAP with a secondary LDAP server.

## Parameters

### -name

Specifies the name of the identity provider.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -domainName

Specifies the domain name of the identity provider.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -username

Specifies the username for the identity provider.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -password

Specifies the password for the identity provider.

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

### -ldapsCert

Specifies the LDAPS certificate file.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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

Required: False
Position: 6
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

Required: False
Position: 7
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

Required: False
Position: 8
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
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
