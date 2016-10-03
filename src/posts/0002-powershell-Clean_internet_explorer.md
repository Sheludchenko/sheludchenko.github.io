	[CmdletBinding()]
	param(
	    [Parameter(Mandatory=$true)]
	    [string]$Name,
	    [Parameter(Mandatory=$true)]
	    [string]$User,
	    [Parameter(Mandatory=$true)]
	    [string]$ActionPath,
	    [Parameter(Mandatory=$true)]
	    [string]$ActionArguments
	)
	
	$Service = New-Object -ComObject("Schedule.Service")
	$Service.Connect()
	$RootFolder = $Service.GetFolder("\")
	
	$TaskDefinition = $Service.NewTask(0) 
	$TaskDefinition.Settings.Enabled = $true
	$TaskDefinition.Settings.AllowDemandStart = $true
	$TaskDefinition.Settings.AllowHardTerminate = $true
	
	$Action = $TaskDefinition.Actions.Create(0)
	$Action.Path = $ActionPath
	$Action.Arguments = $ActionArguments
	
	$RootFolder.RegisterTaskDefinition($Name,$TaskDefinition,6,$User,$null,3) | Out-Null
	
	($RootFolder.GetTask($Name)).Run($null) | Out-Null
	$RootFolder.DeleteTask($Name,0)