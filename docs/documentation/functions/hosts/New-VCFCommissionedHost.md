# New-VCFCommissionedHost

## Synopsis

Commission a list of ESXi hosts.

## Syntax

```powershell
New-VCFCommissionedHost [-json] <String> [-validate] [<CommonParameters>]
```

## Description

The New-VCFCommissionedHost cmdlet commissions a list of ESXi hosts.

## Examples

### Example 1

```powershell
New-VCFCommissionedHost -json .\Host\commissionHosts\commissionHostSpec.json
```

This example shows how to commission a list of ESXi hosts using a JSON specification file.

### Example 2

```powershell
New-VCFCommissionedHost -json .\Host\commissionHosts\commissionHostSpec.json -validate
```

This example shows how to validate the ESXi host JSON specification file.

???+ example "Sample JSON: Commision Hosts"

    ```json
    [
    {
        "fqdn": "sfo01-w01-esx01.sfo.rainpole.io",
        "username": "root",
        "storageType": "VSAN",
        "password": "VMw@re1!",
        "networkPoolName": "sfo-w01-np01",
        "networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"
    },
    {
        "fqdn": "sfo01-w01-esx02.sfo.rainpole.io",
        "username": "root",
        "storageType": "VSAN",
        "password": "VMw@re1!",
        "networkPoolName": "sfo-w01-np01",
        "networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"
    },
    {
        "fqdn": "sfo01-w01-esx03.sfo.rainpole.io",
        "username": "root",
        "storageType": "VSAN",
        "password": "VMw@re1!",
        "networkPoolName": "sfo-w01-np01",
        "networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"
    },
    {
        "fqdn": "sfo01-w01-esx04.sfo.rainpole.io",
        "username": "root",
        "storageType": "VSAN",
        "password": "VMw@re1!",
        "networkPoolName": "sfo-w01-np01",
        "networkPoolId": "1cb5a82e-b1b0-4d98-9d99-544a22875584"
    }
    ]
    ```

## Parameters

### -json

Specifies the JSON specification to be used.

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

### -validate

Specifies that the JSON specification should be validated.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
