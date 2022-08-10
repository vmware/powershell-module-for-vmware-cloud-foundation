---
title: "Restart-CloudBuilderSDDC"
weight: 3
description: >
    Retry a failed Management Domain deployment task
---

## Syntax
``` powershell
Restart-CloudBuilderSDDC -id <string>
```

### Parameters

| Required | Parameter | Type     |  Description                                                                                                    |
| ---------| ----------|----------| --------------------------------------------------------------------------------------------------------------- |
| required | id        | String   | Specifies the unique ID of the Management Domain deployment task                                                |
| optional | json      | String   | Specifies the JSON specification file to be used with the retry                                                 | 

## Examples
### Example 1
``` powershell
Restart-CloudBuilderSDDC -id bedf19f8-9dfe-4c60-aae4-bca986a65a31
```
Retries a failed Management Domain deployment task by unique ID

### Example 2
``` powershell
Restart-CloudBuilderSDDC -id bedf19f8-9dfe-4c60-aae4-bca986a65a31 -json .\SampleJSON\SDDC\SddcSpec.json
```
This example retries a deployment on Cloud Builder based on the ID with an updated JSON file
