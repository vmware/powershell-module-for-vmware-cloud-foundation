# Join-VCFFederation

### Synopsis
Join an VMware Cloud Foundation instance to a Federation

### Syntax
```
Join-VCFFederation -json <json file>
```

### Description
The Join-VCFFederation cmdlet joins a VMware Cloud Foundation instance an existing VMware Cloud Foundation
Federation (Multi-Instance configuration).

### Examples
#### Example 1
```
Join-VCFFederation -json .\joinVCFFederationSpec.json
```
This example demonstrates how to join an VCF Federation by referencing config info in JSON file.

### Parameters

#### -json
Path to the json spec

```yaml
Type: JSON
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Sample JSON
```
{
    "controllerFqdn" : "sfo-vcf01.sfo.rainpole.io",
    "joinToken" : "522c566-836b-44c2-bf84-92dcc7e00764",
    "commonName" : "nyc-vcf01.myc.rainpole.io",
    "memberJoinDetail" : {
      "role" : "MEMBER",
      "fqdn" : "nyc-vcf01.nyc.rainpole.io",
      "siteType" : "DATACENTER",
      "siteName" : "New York Epic Center",
      "country" : "USA",
      "state" : "New York",
      "city" : "New York",
      "coordinate" : {
        "longitude" : -74.006,
        "latitude" : 40.712
      }
    }
  }
```

### Notes

### Related Links
