---
title: "Get-VCFCertificate"
weight: 1
description: >
    Retrieve the latest generated certificate(s) for a domain
---

## Syntax
``` powershell
Get-VCFCertificate -domainName <string> -resources
```

### Parameters

| Required | Parameter   | Type     |  Description                                                   |
| ---------| ------------|----------| -------------------------------------------------------------- |
| required | domainName  | String   | Specifies the name of the domain                               | 
| optional | resources   | Switch   | Specifies retrieving the certificates for the resources        |

## Examples
### Example 1
``` powershell
Get-VCFCertificate -domainName sfo-m01
```
Retrieves a list of certificates that have been generated for the domain

### Example 2
``` powershell
Get-VCFCertificate -domainName sfo-m01 | ConvertTo-Json
```
Retrieves a list of certificates that have been generated for the domain and displays them in JSON format

### Example 3
``` powershell
Get-VCFCertificate -domainName sfo-m01 | Select-Object issuedTo
```
Retrieves a list of certificates that have been generated for the domain, returning only issuedTo data

### Example 4
``` powershell
Get-VCFCertificate -domainName sfo-m01 -resources
```
Retrieves a list of certificates installed for all resources in the domain

### Example 5
``` powershell
Get-VCFCertificate -domainName sfo-m01 -resources | Select-Object issuedTo, numberOfDaysToExpire
```
Retrieves a list of certificates installed for all resources in the domain, returning only issuedTo and numberOfDaysToExpire data