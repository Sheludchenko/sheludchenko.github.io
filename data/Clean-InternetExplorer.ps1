[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$User
)

$Service = New-Object -ComObject("Schedule.Service")
$Service.Connect()
$RootFolder = $Service.GetFolder("\")

$TaskDefinition = $Service.NewTask(0) 
$TaskDefinition.Settings.Enabled = $true
$TaskDefinition.Settings.AllowDemandStart = $true
$TaskDefinition.Settings.AllowHardTerminate = $true

$Action = $TaskDefinition.Actions.Create(0)
$Action.Path = "RunDll32.exe"
$Action.Arguments = " InetCpl.cpl, ClearMyTracksByProcess 255"

$RootFolder.RegisterTaskDefinition("CleanInternetExplorer",$TaskDefinition,6,$User,$null,3) | Out-Null

($RootFolder.GetTask("CleanInternetExplorer")).Run($null) | Out-Null
$RootFolder.DeleteTask("CleanInternetExplorer",0)