---
title: "Join-VCFFederation"
weight: 3
description: >
    Join an VMware Cloud Foundation instance to a Federation (Multi-Instance Management)
---

{{% alert title="Warning" color="warning" %}} The Federation (Multi-Instance Management) feature of VMware Cloud Foundation has been depreciated in VMware Cloud Foundation v4.4.0 and later. {{% /alert %}}

## Syntax
``` powershell
Join-VCFFederation -json <json_file>
```

### Parameters

| Required | Parameter | Type     |  Description                                                   |
| ---------| ----------|----------| -------------------------------------------------------------- |
| required | json      | String   | Specifies the JSON specification file to be used               | 

## Examples
### Example 1
``` powershell
Join-VCFFederation -json .\joinVCFFederationSpec.json
```
Joins a VMware Cloud Foundation instance to a Federation (Multi-Instance Management) by referencing configuration in the json file

## Sample JSON
### Join Member to Federation
``` json
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
