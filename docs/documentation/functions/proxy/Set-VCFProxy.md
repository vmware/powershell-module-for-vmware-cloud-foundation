# Set-VCFProxy

## Synopsis

Sets the proxy configuration for the SDDC Manager.

## Syntax

```powershell
Set-VCFProxy -status <String> [-proxyHost <String>] [-proxyPort <Int32>] [<Common Parameters>]
```

## Description

The `Set-VCFProxy` cmdlet sets the proxy configuration of the SDDC Manager.

???+ note

    This cmdlet will not clear the proxy configuration.

## Examples

### Example 1

```powershell
Set-VCFProxy -status ENABLED -proxyHost proxy.rainpole.io -proxyPort 3128
```

This example shows how to enable the proxy configuration of the SDDC Manager.

### Example 2

```powershell
Set-VCFProxy -status DISABLED
```

This example shows how to disable the proxy configuration of the SDDC Manager.

## Parameters

### -status

Enable or disable the proxy configuration.

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

### -proxyHost

The fully qualified domain name or IP address of the proxy.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -proxyPort

The port number of the proxy.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_Common Parameters](http://go.microsoft.com/fwlink/?LinkID=113216).
