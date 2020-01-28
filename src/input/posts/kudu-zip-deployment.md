Title: Kudu zip deployment
Published: 1/28/2020
Tags:
    - Azure
    - Kudu
    - App Service
    - Powershell
---

    $SiteName = "webapp"
    $SitePassword = "You can get it from publish profile"
    $ApiUrl = "https://$SiteName.scm.azurewebsites.de/api/zipdeploy"
    $ArchivePath = "WebApp.zip"
    
    $Base64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "`$$SiteName", $SitePassword)))
    $Headers = @{Authorization=("Basic {0}" -f $Base64)}
    Invoke-RestMethod -Uri $ApiUrl `
                      -Headers $Headers `
                      -UserAgent "powershell/1.0" `
                      -Method POST -InFile $ArchivePath `
                      -ContentType "multipart/form-data"