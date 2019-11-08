Title: Load Azure PowersShell on the fly
Published: 11/8/2019
Tags:
    - Powershell
    - Azure
    - NuGet
    - Module
---

Sometimes installing modules on the system is not an option. E.g. build servers or any kind of machines where you want to run non-standard cmdlet but you don't want to (or not allowed to) install anything.

In order to do it you need three files.

**load.ps1** - does the heavy lifting. Just look at the script. Everything works pretty straight forward.

    $modulesPath = ".\modules"

    # Cleanup
    Remove-Module Az*
    Remove-Item -Path $modulesPath -Force -Recurse

    # Download nuget.exe in case you don't have it
    Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile "nuget.exe"

    # Restore packages from PowerShell Gallery
    & ".\nuget.exe" "restore" "packages.config" "-packagesdirectory" $modulesPath

    # Remove version portion from each package folder (otherwise system will not recognize modules)
    Get-ChildItem $modulesPath -Directory | % { 
        Rename-Item -Path $_.FullName -NewName $($_.Name -replace "\.\d+\.\d+\.\d+","") 
    }

    # Add our module folder to the system modules path
    $env:PSModulePath += ";$(Resolve-Path -Path $modulesPath)"

    # Import Az module
    Import-Module Az


**nuget.config** - defines package source. By default nuget.exe will use nuget.org or any other repository defined on a user/system level. The chances that it already has PowerShell Gallery in it is pretty low (at least in the environments I work with).

    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
    <packageSources>
        <add key="powershellgallery.com" value="https://www.powershellgallery.com/api/v2/" protocolVersion="2" />
    </packageSources>
    <config>
        <add key="signatureValidationMode" value="Accept" />
    </config>
    </configuration>

**packages.config** - holds the list of packages. In our case we're getting Az 2.8.0 but it can be adjusted to download virtually any number/kind of modules (don't forget to add Import-Module statements for any other module(s) you add).

    <?xml version="1.0" encoding="utf-8"?>
    <packages>
        <package id="Az" version="2.8.0" />
        <package id="Az.Accounts" version="1.6.4" />
        <package id="Az.Advisor" version="1.0.1" />
        <package id="Az.Aks" version="1.0.2" />
        <package id="Az.AnalysisServices" version="1.1.1" />
        <package id="Az.ApiManagement" version="1.3.2" />
        <package id="Az.ApplicationInsights" version="1.0.2" />
        <package id="Az.Automation" version="1.3.4" />
        <package id="Az.Batch" version="1.1.2" />
        <package id="Az.Billing" version="1.0.1" />
        <package id="Az.Cdn" version="1.3.1" />
        <package id="Az.CognitiveServices" version="1.2.1" />
        <package id="Az.Compute" version="2.7.0" />
        <package id="Az.ContainerInstance" version="1.0.1" />
        <package id="Az.ContainerRegistry" version="1.1.0" />
        <package id="Az.DataFactory" version="1.4.0" />
        <package id="Az.DataLakeAnalytics" version="1.0.1" />
        <package id="Az.DataLakeStore" version="1.2.3" />
        <package id="Az.DeploymentManager" version="1.0.1" />
        <package id="Az.DevTestLabs" version="1.0.0" />
        <package id="Az.Dns" version="1.1.1" />
        <package id="Az.EventGrid" version="1.2.2" />
        <package id="Az.EventHub" version="1.4.0" />
        <package id="Az.FrontDoor" version="1.1.1" />
        <package id="Az.HDInsight" version="2.0.2" />
        <package id="Az.HealthcareApis" version="1.0.0" />
        <package id="Az.IotHub" version="1.3.1" />
        <package id="Az.KeyVault" version="1.3.1" />
        <package id="Az.LogicApp" version="1.3.1" />
        <package id="Az.MachineLearning" version="1.1.1" />
        <package id="Az.ManagedServices" version="1.0.1" />
        <package id="Az.MarketplaceOrdering" version="1.0.1" />
        <package id="Az.Media" version="1.1.0" />
        <package id="Az.Monitor" version="1.4.0" />
        <package id="Az.Network" version="1.15.0" />
        <package id="Az.NotificationHubs" version="1.1.0" />
        <package id="Az.OperationalInsights" version="1.3.3" />
        <package id="Az.PolicyInsights" version="1.1.3" />
        <package id="Az.PowerBIEmbedded" version="1.1.0" />
        <package id="Az.RecoveryServices" version="1.4.5" />
        <package id="Az.RedisCache" version="1.1.1" />
        <package id="Az.Relay" version="1.0.2" />
        <package id="Az.Resources" version="1.7.0" />
        <package id="Az.ServiceBus" version="1.4.0" />
        <package id="Az.ServiceFabric" version="1.2.0" />
        <package id="Az.SignalR" version="1.1.0" />
        <package id="Az.Sql" version="1.15.0" />
        <package id="Az.Storage" version="1.8.0" />
        <package id="Az.StorageSync" version="1.2.1" />
        <package id="Az.StreamAnalytics" version="1.0.0" />
        <package id="Az.TrafficManager" version="1.0.2" />
        <package id="Az.Websites" version="1.5.0" />
    </packages>
