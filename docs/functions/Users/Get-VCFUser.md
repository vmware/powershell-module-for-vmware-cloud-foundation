# Get-VCFUser

### Synopsis
Get all Users

### Syntax
```
Get-VCFUser -type <USER, GROUP, SERVICE>
```

### Description
The Get-VCFUser cmdlet gets a list of users, groups and service users in SDDC Manager

### Examples
#### Example 1
```
Get-VCFUser
```
This example list all users, groups and service users in SDDC Manager

#### Example 2
```
Get-VCFUser -type USER
```
This example list all users in SDDC Manager

#### Example 3
```
Get-VCFUser -type GROUP
```
This example list all groups in SDDC Manager

#### Example 4
```
Get-VCFUser -type SERVICE
```
This example list all service users in SDDC Manager

#### Example 5
```
Get-VCFUser -domain rainpole.io
```
This example list all users and groups based on the authentication domain provided in SDDC Manager

### Parameters

#### -type
- Type of user, supported types include USER, GROUP, SERVICE

```yaml
Type: string
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Supported Value: USER, GROUP, SERVICE
```

#### -domain
- The authentication domian

```yaml
Type: string
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Supported Value: Any
```

### Notes

### Related Links
