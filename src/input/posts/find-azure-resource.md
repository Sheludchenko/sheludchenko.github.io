Title: Find Azure resource across all subscriptions
Published: 1/10/2020
Tags:
    - Azure
    - Powershell
---

    Get-AzSubscription | % {
      Select-AzSubscription $_
      Get-AzResource | Where-Object {$_.Name -match "<resource name>"} | Select-Object *
    }