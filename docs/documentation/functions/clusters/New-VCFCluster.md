# New-VCFCluster

## Synopsis

Creates a cluster in a workload domains.

## Syntax

```powershell
New-VCFCluster [-json] <String> [<CommonParameters>]
```

## Description

The `New-VCFCluster` cmdlet connects to the creates a cluster in a workload domain from a JSON specification file.

## Examples

### Example 1

```powershell
New-VCFCluster -json .\samples\clusters\clusterSpec.json
```

This example shows how to create a cluster in a workload domain from a JSON specification file.

???+ example "Sample JSON: Cluster Configuration"

    ```json
    {
    "nsxVClusterSpec": {
        "vdsNameForVxlanConfig": "w01-c02-vds02",
        "vlanId": 0
    },
    "hostSpec": {
        "hostSystemSpec": [
        {
            "license": "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX",
            "id": "c2398611-23cd-4b94-b2e3-9d84848b73cb",
            "vmnicToVdsNameMap": {
            "vmnic0": "w01-c02-vds01",
            "vmnic1": "w01-c02-vds01",
            "vmnic2": "w01-c02-vds02",
            "vmnic3": "w01-c02-vds02"
            }
        },
        {
            "license": "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX",
            "id": "8dbe7dcb-f409-4ccd-984b-711e70e9e767",
            "vmnicToVdsNameMap": {
            "vmnic0": "w01-c02-vds01",
            "vmnic1": "w01-c02-vds01",
            "vmnic2": "w01-c02-vds02",
            "vmnic3": "w01-c02-vds02"
            }
        },
        {
            "license": "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX",
            "id": "e9ba66e0-4670-4973-bdb1-bc05702ca91a",
            "vmnicToVdsNameMap": {
            "vmnic0": "w01-c02-vds01",
            "vmnic1": "w01-c02-vds01",
            "vmnic2": "w01-c02-vds02",
            "vmnic3": "w01-c02-vds02"
            }
        }
        ]
    },
    "clusterName": "c02",
    "highAvailabilitySpec": {
        "enabled": true
    },
    "domainId": "983840c1-fa13-4edd-b3cb-907a95c29652",
    "datastoreSpec": {
        "vsanDatastoreSpec": {
        "license": "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX",
        "ftt": 1,
        "name": "w01-c02-vsan01"
        }
    },
    "vdsSpec": [
        {
        "name": "w01-c02-vds01",
        "portGroupSpec": [
            {
            "name": "w01-c02-vds01-management",
            "transportType": "MANAGEMENT"
            },
            {
            "name": "w01-c02-vds01-vmotion",
            "transportType": "VMOTION"
            },
            {
            "name": "w01-c02-vds01-vsan",
            "transportType": "VSAN"
            }
        ]
        },
        {
        "name": "w01-c02-vds02",
        "portGroupSpec": [
            {
            "name": "w01-c02-vds02-ext",
            "transportType": "PUBLIC"
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

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
