# New-VCFNetworkPool

## Synopsis

Creates a network pool.

## Syntax

```powershell
New-VCFNetworkPool [-json] <String> [<CommonParameters>]
```

## Description

The New-VCFNetworkPool cmdlet creates a network pool.

## Examples

### Example 1

```powershell
New-VCFNetworkPool -json .\NetworkPool\createNetworkPoolSpec.json
```

This example shows how to create a new network pool using a JSON specification file.

???+ example "Sample JSON: Network Pool Configuration"

    ```json
    {
      "name": "sfo-np01",
      "networks": [
        {
          "type": "VSAN",
          "vlanId": 2240,
          "mtu": 9000,
          "subnet": "172.16.240.0",
          "mask": "255.255.255.0",
          "gateway": "172.16.240.253",
          "ipPools": [
            {
              "start": "172.16.240.5",
              "end": "172.16.240.100"
            }
          ]
        },
        {
          "type": "VMOTION",
          "vlanId": 2236,
          "mtu": 9000,
          "subnet": "172.16.236.0",
          "mask": "255.255.255.0",
          "gateway": "172.16.236.253",
          "ipPools": [
            {
              "start": "172.16.236.5",
              "end": "172.16.236.100"
            }
          ]
        }
      ]
    }
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

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
