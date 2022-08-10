---
title: "Start-VCFBundleUpload"
weight: 3
description: >
    Starts the upload of bundle to SDDC Manager
---

## Syntax
``` powershell
Start-VCFBundleUpload -json <path to json file>
```

---
**Prerequisite**

The bundle should have been downloaded to SDDC Manager VM using the bundle transfer utility tool

---

### Parameters

| Required | Parameter | Type     |  Description                                                   |
| ---------| ----------|----------| -------------------------------------------------------------- |
| required | json      | String   | Specifies the JSON specification file to be used               | 

## Examples
### Example 1
``` powershell
Start-VCFBundleUpload -json .\Bundle\bundlespec.json
```
Invokes the upload of a bundle in to SDDC Manager