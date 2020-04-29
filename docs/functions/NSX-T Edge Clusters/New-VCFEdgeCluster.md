# New-VCFEdgeCluster

### Synopsis
Connects to the specified SDDC Manager and creates an NSX-T edge Cluster.

### Syntax
```
New-VCFEdgeCluster -json <path to JSON file>
```

### Description
The New-VCFEdgeCluster cmdlet connects to the specified SDDC Manage & creates an NSX-T edge cluster.


### Examples
#### Example 1
```
New-VCFEdgeCluster -json .\SampleJSON\EdgeClusters\edgeClusterSpec.json
```
This example shows how to create an NSX-T edge Cluster

#### Example 2
```
New-VCFEdgeCluster -json .\SampleJSON\EdgeClusters\edgeClusterSpec.json -validate
```
This example shows how to validate the JSON spec for Edge Cluster creation

### Parameters

#### -json
- Path to JSON file

```yaml
Type: JSON
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Sample JSON
```json
{
   "edgeClusterName":"sfo-m01-ec01",
   "edgeClusterType":"NSX-T",
   "edgeRootPassword":"VMw@re1!VMw@re1!",
   "edgeAdminPassword":"VMw@re1!VMw@re1!",
   "edgeAuditPassword":"VMw@re1!VMw@re1!",
   "edgeFormFactor":"MEDIUM",
   "tier0ServicesHighAvailability":"ACTIVE_ACTIVE",
   "mtu":9000,
   "asn":65000,
   "tier0RoutingType":"STATIC",
   "tier0Name": "sfo-m01-ec01-t0-gw01",
   "tier1Name": "sfo-m01-ec01-t1-gw01",
   "edgeClusterProfileType": "CUSTOM",
   "edgeClusterProfileSpec": 
    {  "bfdAllowedHop": 255,
       "bfdDeclareDeadMultiple": 3,
       "bfdProbeInterval": 1000,
       "edgeClusterProfileName": "sfo-m01-ecp01",
       "standbyRelocationThreshold": 30 
    },
   "edgeNodeSpecs":[
      {
         "edgeNodeName":"sfo-m01-en01.sfo.rainpole.io",
         "managementIP":"172.16.225.69/24",
         "managementGateway":"172.16.225.1",
         "edgeTepGateway":"172.16.233.1",
         "edgeTep1IP":"172.16.233.2/24",
         "edgeTep2IP":"172.16.233.3/24",
         "edgeTepVlan":"2233",
         "clusterId":"24b5264d-f662-43ab-8523-b6911feb880f",
         "interRackCluster": "false",
         "uplinkNetwork":[
            {
               "uplinkVlan":2228,
               "uplinkInterfaceIP":"172.16.228.2/24"
            },
            {
               "uplinkVlan":2229,
               "uplinkInterfaceIP":"172.16.229.2/24"
            }
         ]
      },
      {
         "edgeNodeName":"sfo-m01-en02.sfo.rainpole.io",
         "managementIP":"172.16.225.70/24",
         "managementGateway":"172.16.225.1",
         "edgeTepGateway":"172.16.233.1",
         "edgeTep1IP":"172.16.233.4/24",
         "edgeTep2IP":"172.16.233.5/24",
         "edgeTepVlan":"2233",
         "clusterId":"24b5264d-f662-43ab-8523-b6911feb880f",
         "interRackCluster": "false",
         "uplinkNetwork":[
            {
               "uplinkVlan":2228,
               "uplinkInterfaceIP":"172.16.228.3/24"
            },
            {
               "uplinkVlan":2229,
               "uplinkInterfaceIP":"172.16.229.3/24"
            }
         ]
      }
   ]
}
```

### Notes

### Related Links
